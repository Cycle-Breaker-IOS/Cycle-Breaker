/* ─ The Cycle Breaker — Service Worker ─ */
'use strict';

const CACHE_NAME = 'cb-notifications';

/* ── PUSH (from push server, for future use) ── */
self.addEventListener('push', event => {
  const defaults = { title: 'The Cycle Breaker', body: 'Time to check in.' };
  let data = defaults;
  try { data = event.data ? event.data.json() : defaults; } catch (_) {}

  event.waitUntil(
    self.registration.showNotification(data.title, {
      body:               data.body,
      icon:               '/icon-192.png',
      badge:              '/icon-192.png',
      tag:                'cycle-breaker-daily',
      requireInteraction: false,
    })
  );
});

/* ── NOTIFICATION CLICK ── */
self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(clients.openWindow('/'));
});

/* ── MESSAGES FROM MAIN THREAD ── */
self.addEventListener('message', event => {
  if (!event.data) return;
  switch (event.data.type) {
    case 'SCHEDULE_NOTIFICATION':
      event.waitUntil(storeSchedule(event.data.payload, event.data.hour));
      break;
    case 'CANCEL_NOTIFICATION':
      event.waitUntil(clearSchedule());
      break;
  }
});

/* ── ACTIVATE: claim clients + check if a notification is due ── */
self.addEventListener('activate', event => {
  event.waitUntil(
    self.clients.claim().then(() => checkAndNotify())
  );
});

/* ── FETCH: passthrough (required for SW registration) ── */
self.addEventListener('fetch', () => {});

/* ─── helpers ─── */

async function storeSchedule(payload, hour) {
  const cache = await caches.open(CACHE_NAME);
  await cache.put('/cb-schedule', new Response(JSON.stringify({ payload, hour })));
}

async function clearSchedule() {
  const cache = await caches.open(CACHE_NAME);
  await cache.delete('/cb-schedule');
  await cache.delete('/cb-last-sent');
}

async function checkAndNotify() {
  try {
    const cache    = await caches.open(CACHE_NAME);
    const schedRes = await cache.match('/cb-schedule');
    if (!schedRes) return;

    const { payload, hour } = JSON.parse(await schedRes.text());
    const now = new Date();

    if (now.getHours() < hour) return;             // too early today

    const today       = now.toDateString();
    const lastSentRes = await cache.match('/cb-last-sent');
    if (lastSentRes && (await lastSentRes.text()) === today) return; // already sent today

    await self.registration.showNotification(payload.title, {
      body:               payload.body,
      icon:               '/icon-192.png',
      badge:              '/icon-192.png',
      tag:                'cycle-breaker-daily',
      requireInteraction: false,
    });

    await cache.put('/cb-last-sent', new Response(today));
  } catch (_) { /* silent fail */ }
}
