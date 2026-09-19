/**
 * One Serverless Function for /api/qa/faq and /api/qa/questions.
 * See api/auth/[action].ts for why these are not separate files.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  clientKey,
  getAuthFromRequest,
  originAllowed,
  parseJsonBody,
  rateLimit,
  setAuthCors,
} from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { enqueueQuestionAdminEmails, processOutbox } from '../../lib/email';

const QUESTION_MIN = 10;
const QUESTION_MAX = 2000;

function actionName(req: VercelRequest): string {
  const raw = req.query.action;
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

async function handleFaq(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(
      `SELECT id::text, question, answer
         FROM faq_items
        WHERE published = true
        ORDER BY sort_order ASC, published_at ASC`
    );
    return res.status(200).json({ items: rows });
  } catch (err) {
    console.error('qa faq error', err);
    return res.status(500).json({ error: 'Failed to load FAQ' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleQuestions(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });

  const ip = clientKey(req);
  if (!rateLimit(`ask:${jwtUser.id}`, 5, 60 * 60 * 1000) || !rateLimit(`ask-ip:${ip}`, 20, 60 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many questions' });
  }

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });
  const question = typeof body.question === 'string' ? body.question.trim() : '';
  if (question.length < QUESTION_MIN || question.length > QUESTION_MAX) {
    return res.status(400).json({ error: 'Question must be 10-2000 characters' });
  }
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    const inserted = await client.query(
      `INSERT INTO user_questions (user_id, question)
       VALUES ($1, $2)
       RETURNING id::text, question, created_at`,
      [jwtUser.id, question]
    );
    const row = inserted.rows[0];
    try {
      await enqueueQuestionAdminEmails(client, {
        questionId: row.id,
        askerEmail: jwtUser.email,
        question,
      });
      await processOutbox(client);
    } catch (err) {
      console.error('question admin email failed', err);
    }
    return res.status(201).json({ id: row.id, createdAt: row.created_at });
  } catch (err) {
    console.error('qa questions error', err);
    return res.status(500).json({ error: 'Failed to submit question' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();

  switch (actionName(req)) {
    case 'faq':
      return handleFaq(req, res);
    case 'questions':
      return handleQuestions(req, res);
    default:
      return res.status(404).json({ error: 'Not found' });
  }
}
