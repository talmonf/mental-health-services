/**
 * Bot identification, shared by middleware.ts and api/bot-report.ts.
 *
 * The distinction between kinds is not cosmetic. Search and answer crawlers fetch live and
 * will reflect a correction to a phone number; training crawlers bake in a snapshot and may
 * keep repeating a stale one. robots.txt allows both, and that choice is only defensible if
 * we can actually see which is happening.
 */

export type BotKind = 'ai_training' | 'ai_search' | 'search' | 'social' | 'other';

export interface BotMatch {
  name: string;
  kind: BotKind;
}

/** Ordered: the first match wins, so more specific tokens come before broader ones. */
const BOT_PATTERNS: Array<[RegExp, string, BotKind]> = [
  // AI answer engines and search-time fetchers. These see corrections.
  [/OAI-SearchBot/i, 'OAI-SearchBot', 'ai_search'],
  [/ChatGPT-User/i, 'ChatGPT-User', 'ai_search'],
  [/PerplexityBot/i, 'PerplexityBot', 'ai_search'],
  [/Perplexity-User/i, 'Perplexity-User', 'ai_search'],
  [/Claude-SearchBot/i, 'Claude-SearchBot', 'ai_search'],
  [/Claude-User/i, 'Claude-User', 'ai_search'],
  [/DuckAssistBot/i, 'DuckAssistBot', 'ai_search'],

  // AI training crawlers. These bake in a snapshot.
  // GPTBot before the generic OpenAI token, ClaudeBot before Claude-*.
  [/GPTBot/i, 'GPTBot', 'ai_training'],
  [/ClaudeBot/i, 'ClaudeBot', 'ai_training'],
  [/anthropic-ai/i, 'anthropic-ai', 'ai_training'],
  [/CCBot/i, 'CCBot', 'ai_training'],
  [/Google-Extended/i, 'Google-Extended', 'ai_training'],
  [/Applebot-Extended/i, 'Applebot-Extended', 'ai_training'],
  [/Bytespider/i, 'Bytespider', 'ai_training'],
  [/Amazonbot/i, 'Amazonbot', 'ai_training'],
  [/meta-externalagent/i, 'meta-externalagent', 'ai_training'],
  [/cohere-ai/i, 'cohere-ai', 'ai_training'],
  [/Diffbot/i, 'Diffbot', 'ai_training'],
  [/Timpibot/i, 'Timpibot', 'ai_training'],
  [/omgili/i, 'omgili', 'ai_training'],

  // Conventional search. Googlebot last among Google tokens so Google-Extended wins first.
  [/Bingbot/i, 'Bingbot', 'search'],
  [/Googlebot/i, 'Googlebot', 'search'],
  [/AdsBot-Google/i, 'AdsBot-Google', 'search'],
  [/DuckDuckBot/i, 'DuckDuckBot', 'search'],
  [/YandexBot/i, 'YandexBot', 'search'],
  [/Baiduspider/i, 'Baiduspider', 'search'],
  [/Applebot/i, 'Applebot', 'search'],
  [/SeznamBot/i, 'SeznamBot', 'search'],

  // Social unfurlers. Relevant because distribution today is WhatsApp and Facebook.
  [/facebookexternalhit/i, 'facebookexternalhit', 'social'],
  [/WhatsApp/i, 'WhatsApp', 'social'],
  [/Twitterbot/i, 'Twitterbot', 'social'],
  [/TelegramBot/i, 'TelegramBot', 'social'],
  [/LinkedInBot/i, 'LinkedInBot', 'social'],
  [/Slackbot/i, 'Slackbot', 'social'],

  // SEO and generic crawlers, lumped together. Volume matters, identity does not.
  [/AhrefsBot|SemrushBot|MJ12bot|DotBot|BLEXBot|PetalBot|DataForSeoBot/i, 'seo-crawler', 'other'],
  [/\bbot\b|crawler|spider|crawling/i, 'unknown-bot', 'other'],
];

export function identifyBot(userAgent: string | null | undefined): BotMatch | null {
  if (!userAgent) return null;
  for (const [pattern, name, kind] of BOT_PATTERNS) {
    if (pattern.test(userAgent)) return { name, kind };
  }
  return null;
}

/** The agents the GEO experiment gates on. A zero here means "not testable", not "no effect". */
export const GEO_GATE_AGENTS = [
  'GPTBot',
  'ClaudeBot',
  'CCBot',
  'OAI-SearchBot',
  'ChatGPT-User',
  'PerplexityBot',
  'Claude-SearchBot',
  'Googlebot',
  'Bingbot',
];
