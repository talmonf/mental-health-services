---
name: Add Addictions Section ICA
overview: Add a new "התמכרויות" (Addictions) section to the mental health directory with a card for the Israeli Center for Addictions (ICA) at https://ica.org.il/, with simplified fields and icon-only contact buttons.
todos: []
isProject: false
---

# Add Addictions Section with ICA Card

## Current Structure

The webpage ([index.html](index.html)) is a single-file React app with:

- **DATA object**: Categories (emergency, helplines, portals, rights, moh, mod, hmo, hospitalization, alternatives, rehabilitation, therapists, treatments, trauma, families, youth, populations, facebook, nutrition, local, transport)
- **Service card fields**: `org`, `svc`, `phone`, `web`, `email`, `target`, `region`, `cost`, `specialty`, `notes`, `languages`, `diseases`, `add`, plus optional `phone2`–`phone6`, `whatsapp`, `dir`, `iconOnly`
- **CAT_ICONS** mapping: Maps each category ID to a Font Awesome icon
- **Card component**: Renders org, svc, metadata block, and action buttons

ICA currently appears only in the **treatments** section (row 89) with minimal data.

---

## ICA Card Data (per user requirements)


| Field      | Value                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------- |
| **org**    | המרכז הישראלי להתמכרויות (ICA)                                                              |
| **svc**    | מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות |
| **phone**  | 09-9789510                                                                                  |
| **phone2** | 09-9789500                                                                                  |
| **email**  | [info@ica.org.il](mailto:info@ica.org.il)                                                   |
| **web**    | [https://ica.org.il/](https://ica.org.il/)                                                  |


**Excluded:** `add`, `target`, `region`, `specialty`, `notes`. Svc omits practitioner-focused text (מרפאה, הכשרה למטפלים, מחקר, תוכניות מניעה, קידום מדיניות). Region omitted (serves all Israel). Phone and email: **icons only** (`iconOnly: true`).

---

## Implementation

### 1. Add `addictions` category to DATA

Insert after `treatments` and before `trauma`.

**Category object:**

```javascript
"addictions": {
  "icon": "💊",
  "title": "התמכרויות",
  "titleEn": "Addictions",
  "desc": "טיפול, מניעה ומחקר בתחום ההתמכרויות",
  "services": [
    {
      "row": 94,
      "org": "המרכז הישראלי להתמכרויות (ICA)",
      "svc": "מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות",
      "phone": "09-9789510",
      "phone2": "09-9789500",
      "phoneLabel2": "מרפאה",
      "phoneShowNumber2": false,
      "email": "info@ica.org.il",
      "web": "https://ica.org.il/",
      "iconOnly": true
    }
  ]
}
```

### 2. Add icon to CAT_ICONS

```javascript
addictions: 'fa-pills'
```

### 3. Card component update (for icon-only phone2)

The Card supports `iconOnly` for the first `phone` and for `email`. For `phone2` to show icon-only, add `iconOnly` handling to the phone2–phone6 buttons in the Card component.

---

## ICA Card Result

- **Header**: המרכז הישראלי להתמכרויות (ICA)
- **Description**: svc (no target, region, specialty, notes)
- **Buttons**: Phone icon, Phone icon (clinic), Email icon, Website ("לאתר")
- **No** "add" link

---

## Duplicate Handling

ICA remains in **treatments**. Recommend keeping both (Treatments + Addictions) unless you prefer single placement.