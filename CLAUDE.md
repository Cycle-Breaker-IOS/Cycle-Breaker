CONTEXT — READ THIS BEFORE MAKING ANY CHANGES:

App name: The Cycle Breaker
File: index.html (single file app — all HTML, CSS, 
and JavaScript in one file)
Deployed: Netlify, running as a PWA on iPhone iOS 16.4+
Added to iPhone home screen — opens full screen, no Safari bar

TECH STACK:
Pure HTML, CSS, JavaScript — no frameworks
Service worker file: service-worker.js
PWA manifest: manifest.json
Icons: icon-192.png and icon-512.png
Tabler icons loaded via CDN for all icons
html2canvas loaded via CDN for share card

LOCALSTORAGE KEYS IN USE — do not rename these:
"onboarding_complete" — "true" when onboarding done
"primary_avoidance" — what user said they avoid (string)
"streak" — current break streak number (string)
"cycle_count" — number of cycle days (string)
"last_completed_date" — YYYY-MM-DD of last completion
"todays_move" — text of today's One Move
"total_completions" — total number of mirror completions
"completion_log" — JSON array of YYYY-MM-DD completion dates
"notifications_enabled" — "true" or "false"
"smart_notify_hour" — calculated best hour for notification
"manual_notify_hour" — user-set notification hour override
"open_hours" — JSON array of hours user opens app
"mirror_q1" — user's answer to Daily Mirror question 1
"mirror_q2" — user's answer to Daily Mirror question 2
"mirror_q3" — user's answer to Daily Mirror question 3

SCREENS IN THE APP:
1. Onboarding — 3 separate full screen pages
   Page 1: Hook screen, no back arrow
   Page 2: Quick setup, answer cards, no back arrow
   Page 3: Notifications, one back arrow top left
   After completion goes straight to Daily Mirror

2. Home screen:
   App name, date, headline, streak subline
   Two stat cards (break streak + cycle count)
   7-dot week history row with dynamic message below
   Pattern badge pulling from localStorage
   CTA button OR completion card with countdown timer
   Two secondary buttons (Weekly reveal, Voice note)
   Bottom nav: Home, Patterns, Profile

3. Daily Mirror — 3 questions with dot progress indicator
   Questions tailored to primary_avoidance value
   Each question has 3 dynamic options + 
   "Let me type it" custom input card
   Q1: "What did you avoid doing yesterday?"
   Q2: "What pattern kept showing up?"
   Q3: "What will you commit to today?"

4. One Move screen:
   Pulsing ring animation (sonarPulse, 2s infinite)
   "DO THIS BEFORE NOON" label prominent
   One Move text pulled from pattern logic
   "That's done. Let's go." button (was "I did it")
   "Remind me" button
   "Flex your streak" button — hidden on day 1,
   shows from day 2 onwards (checks total_completions)
   Orange flash transition back to home screen

5. Pattern screen:
   Hero card showing "YOU KEEP AVOIDING" 
   with 28px bold text and "This is your cycle. Name it."
   Rest of pattern data below

6. Settings screen (Profile tab):
   Notification toggle
   Reminder time selector
   Reset all data option

DESIGN RULES — always apply these:
Background: #0f0f0f
Card background: #1a1a1a
Accent color: #E8571A
Primary text: #f0f0f0
Muted text: #555
Very muted text: #333
Inactive/disabled: #444
Card borders: 0.5px solid #2a2a2a
Selected state border: 0.5px solid #E8571A
Selected state background: #1e1410
Border radius on cards: 12-14px
Border radius on buttons: 14px
No emojis anywhere
No gradients
No box shadows except glow on completed streak dots
Font: system default sans-serif
All Tabler icons use "ti-" prefix
