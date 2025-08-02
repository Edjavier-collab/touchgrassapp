# TouchGrass App - User Stories

## Epic 1: Onboarding & Authentication

### US-1: Device Registration
**As a** new user  
**I want to** start using the app immediately without creating an account  
**So that** I can begin tracking my cravings with minimal friction  

**Acceptance Criteria:**
- [ ] App generates unique device ID on first launch
- [ ] Device ID is stored in localStorage
- [ ] Device ID is registered in Supabase
- [ ] User data persists across browser sessions
- [ ] No personal information is required

**Story Points:** 3  
**Priority:** High  
**Sprint:** 1  

### US-2: Data Export & Reset
**As a** user  
**I want to** export or delete my data  
**So that** I maintain control over my personal information  

**Acceptance Criteria:**
- [ ] Export button downloads all user data as JSON
- [ ] Delete button removes all data after confirmation
- [ ] Option to migrate to registered account (future)
- [ ] Clear confirmation dialog before destructive actions

**Story Points:** 5  
**Priority:** Medium  
**Sprint:** 2  

## Epic 2: WOOP Flow

### US-3: Create WOOP Entry
**As a** user  
**I want to** create a WOOP (Wish, Outcome, Obstacle, Plan) entry  
**So that** I can mentally prepare before starting my timer  

**Acceptance Criteria:**
- [ ] Form with 4 text fields (max 280 chars each)
- [ ] All fields are required
- [ ] Autosave every 5 seconds
- [ ] Visual feedback on save status
- [ ] Mobile-friendly input fields

**Story Points:** 5  
**Priority:** High  
**Sprint:** 1  

### US-4: Edit Draft WOOP
**As a** user  
**I want to** edit my WOOP entry before starting the timer  
**So that** I can refine my thoughts  

**Acceptance Criteria:**
- [ ] Edit button available on draft WOOP
- [ ] Changes autosave
- [ ] Cannot edit after timer starts
- [ ] Clear indication of draft vs active state

**Story Points:** 3  
**Priority:** High  
**Sprint:** 1  

## Epic 3: Timer & Tracking

### US-5: Start Craving Timer
**As a** user  
**I want to** start a 24-hour timer after completing my WOOP  
**So that** I can track how long I resist my craving  

**Acceptance Criteria:**
- [ ] Start button begins timer from 0:00:00
- [ ] Timer counts up to 24:00:00
- [ ] Display shows hours:minutes:seconds
- [ ] Timer persists across page refreshes
- [ ] Only one active timer allowed
- [ ] Timer state saved to localStorage

**Story Points:** 8  
**Priority:** High  
**Sprint:** 1  

### US-6: Stop Timer (Success/Slip)
**As a** user  
**I want to** stop my timer when I reach 24 hours or if I slip  
**So that** I can log my progress accurately  

**Acceptance Criteria:**
- [ ] Auto-stop at exactly 24 hours
- [ ] "I slipped" button stops timer early
- [ ] Duration logged in seconds
- [ ] Linked to WOOP entry ID
- [ ] Timestamp recorded
- [ ] Appropriate celebration/encouragement shown

**Story Points:** 5  
**Priority:** High  
**Sprint:** 1  

## Epic 4: Analytics & Progress

### US-7: Progress Visualization
**As a** user  
**I want to** see my progress over time  
**So that** I can stay motivated and track improvement  

**Acceptance Criteria:**
- [ ] Daily line graph shows timer durations
- [ ] Cumulative best bar chart
- [ ] 7-day rolling average trend line
- [ ] Tooltips show date, duration, WOOP wish
- [ ] Empty state for < 3 data points
- [ ] Responsive design for mobile

**Story Points:** 13  
**Priority:** High  
**Sprint:** 2  

### US-8: Streak Tracking
**As a** user  
**I want to** see my current and best streaks  
**So that** I can celebrate consistency  

**Acceptance Criteria:**
- [ ] Current streak counter (consecutive 24h successes)
- [ ] Best streak displayed
- [ ] Streak breaks on slip or missed day
- [ ] Visual indicator for active streak

**Story Points:** 5  
**Priority:** Medium  
**Sprint:** 2  

## Epic 5: Notifications & Engagement

### US-9: 24-Hour Success Notification
**As a** user  
**I want to** receive a congratulations notification at 24 hours  
**So that** I feel accomplished  

**Acceptance Criteria:**
- [ ] Push notification at 24-hour mark
- [ ] Fallback to email if push unavailable
- [ ] Sent within 1 minute of success
- [ ] Celebration message varies
- [ ] Respects notification preferences

**Story Points:** 8  
**Priority:** Medium  
**Sprint:** 3  

### US-10: Early Slip Support
**As a** user who slipped early  
**I want to** receive an encouraging message  
**So that** I don't feel discouraged  

**Acceptance Criteria:**
- [ ] Gentle, supportive message on slip
- [ ] No shame or negative language
- [ ] Suggests trying again
- [ ] Optional tips for next attempt

**Story Points:** 3  
**Priority:** Medium  
**Sprint:** 3  

## Epic 6: Celebrations & Rewards

### US-11: Success Celebrations
**As a** user who reaches 24 hours  
**I want to** see a fun celebration  
**So that** my achievement feels special  

**Acceptance Criteria:**
- [ ] Confetti animation on success
- [ ] Random motivational phrase displayed
- [ ] Celebration duration 3-5 seconds
- [ ] Doesn't block UI interaction
- [ ] Respects reduce-motion preference

**Story Points:** 5  
**Priority:** Medium  
**Sprint:** 2  

### US-12: Sound Effects
**As a** user  
**I want to** hear pleasant sounds for key actions  
**So that** the app feels more engaging  

**Acceptance Criteria:**
- [ ] Success chime at 24 hours
- [ ] Subtle sound on timer start
- [ ] Volume respects device settings
- [ ] Mute toggle in settings
- [ ] No autoplay on page load

**Story Points:** 3  
**Priority:** Low  
**Sprint:** 3  

### US-13: Emoji Rain
**As a** user  
**I want to** see fun emoji animations  
**So that** the app feels modern and playful  

**Acceptance Criteria:**
- [ ] Emoji rain on major milestones
- [ ] Different emojis for different achievements
- [ ] Toggle in settings
- [ ] Respects reduce-motion
- [ ] Doesn't impact performance

**Story Points:** 5  
**Priority:** Low  
**Sprint:** 4  

## Epic 7: Settings & Preferences

### US-14: User Preferences
**As a** user  
**I want to** customize my app experience  
**So that** it works the way I prefer  

**Acceptance Criteria:**
- [ ] Settings page accessible from main nav
- [ ] Toggle notifications on/off
- [ ] Toggle sounds on/off
- [ ] Toggle animations on/off
- [ ] Preferences persist across sessions

**Story Points:** 5  
**Priority:** Medium  
**Sprint:** 2  

## Epic 8: Accessibility & Localization

### US-15: Spanish Language Support
**As a** Spanish-speaking user  
**I want to** use the app in Spanish  
**So that** I can understand everything clearly  

**Acceptance Criteria:**
- [ ] Language toggle in settings
- [ ] All UI strings translated
- [ ] Date/time formats localized
- [ ] Language preference persists
- [ ] No mixed languages on same screen

**Story Points:** 8  
**Priority:** Medium  
**Sprint:** 4  

### US-16: Screen Reader Support
**As a** user with visual impairments  
**I want to** use the app with a screen reader  
**So that** I can track my progress independently  

**Acceptance Criteria:**
- [ ] All interactive elements have labels
- [ ] Proper heading hierarchy
- [ ] ARIA labels for complex UI
- [ ] Focus management for modals
- [ ] Keyboard navigation works throughout

**Story Points:** 8  
**Priority:** High  
**Sprint:** 3  

## Epic 9: Security & Privacy

### US-17: Data Encryption
**As a** user  
**I want** my data to be encrypted  
**So that** my personal struggles remain private  

**Acceptance Criteria:**
- [ ] AES-256 encryption at rest
- [ ] TLS 1.3 for data in transit
- [ ] No sensitive data in URLs
- [ ] Secure session management

**Story Points:** 13  
**Priority:** High  
**Sprint:** 3  

### US-18: Audit Logging
**As a** compliance officer  
**I want** to track data access  
**So that** we maintain HIPAA alignment  

**Acceptance Criteria:**
- [ ] Log all CRUD operations
- [ ] Timestamp and device ID recorded
- [ ] Logs retained for 1 year
- [ ] Quarterly review process
- [ ] No PII in logs

**Story Points:** 8  
**Priority:** Medium  
**Sprint:** 4  

## Sprint Planning Recommendations

### Sprint 1 (MVP Core)
- US-1: Device Registration (3)
- US-3: Create WOOP Entry (5)
- US-4: Edit Draft WOOP (3)
- US-5: Start Craving Timer (8)
- US-6: Stop Timer (5)
**Total: 24 points**

### Sprint 2 (Analytics & Polish)
- US-2: Data Export & Reset (5)
- US-7: Progress Visualization (13)
- US-11: Success Celebrations (5)
- US-14: User Preferences (5)
**Total: 28 points**

### Sprint 3 (Engagement & Accessibility)
- US-8: Streak Tracking (5)
- US-9: 24-Hour Success Notification (8)
- US-10: Early Slip Support (3)
- US-12: Sound Effects (3)
- US-16: Screen Reader Support (8)
- US-17: Data Encryption (13)
**Total: 40 points**

### Sprint 4 (Enhancement & Compliance)
- US-13: Emoji Rain (5)
- US-15: Spanish Language Support (8)
- US-18: Audit Logging (8)
**Total: 21 points**

## Definition of Ready
- [ ] User story has clear acceptance criteria
- [ ] Dependencies identified
- [ ] Design mockups approved (if UI change)
- [ ] Technical approach discussed
- [ ] Story pointed by team

## Definition of Done
- [ ] Code complete and reviewed
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Accessibility tested
- [ ] Mobile responsive verified
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] Product owner approval