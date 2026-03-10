# Think-Thonk UI - Content Feed Application

A modern, minimalist content discovery feed with smooth full-page scrolling and fullscreen content viewing, built with Next.js 16, React 19, and Tailwind CSS 4. This is a professional design system documentation for perfect UI reproduction.

## Key Features
- **Scrollbar-Free Design**: Fully hidden scrollbars across all browsers using aggressive CSS rules for Chrome, Firefox, Safari, and Edge
- **Theme-Aware Text Selection**: Text selection colors match the primary theme automatically with dark mode support
- **Borderless Card Layout**: Removed visible borders for a seamless, modern aesthetic
- **Fullscreen Content Mode**: Click "Fullscreen →" text link (next to "Read More") to view full article content with auto-scrolling
- **Smart Navigation**: Auto-snap to next/previous post when scroll velocity drops, smooth transitions between posts
- **Boundary Indicators**: "You've reached the end" and "Beginning of content" messages with helpful scroll prompts
- **Action Buttons**: Like, Save, and Share buttons available in both feed and fullscreen modes with persistent state
- **Streak Tracking**: Real-time streak counter with flame icon display in header, increments on likes
- **Dark/Light Theme**: Automatic theme switching with system preference detection using oklch color space

---

## 🎨 Design System

### Color Palette

The application uses **oklch** color space for superior color consistency across light and dark modes.

#### Light Mode (Root Variables)
| Token | OKLCH Value | Description |
|-------|-------------|-------------|
| `--background` | `oklch(0.98 0.002 240)` | Main background (near-white) |
| `--foreground` | `oklch(0.15 0.01 240)` | Primary text (near-black) |
| `--card` | `oklch(0.97 0.002 240)` | Card backgrounds (off-white) |
| `--card-foreground` | `oklch(0.15 0.01 240)` | Card text |
| `--primary` | `oklch(0.35 0.01 240)` | Primary interactive elements |
| `--primary-foreground` | `oklch(0.97 0.002 240)` | Text on primary |
| `--secondary` | `oklch(0.65 0.01 240)` | Secondary elements |
| `--secondary-foreground` | `oklch(0.15 0.01 240)` | Text on secondary |
| `--muted` | `oklch(0.88 0.005 240)` | Muted/disabled states |
| `--muted-foreground` | `oklch(0.45 0.01 240)` | Text on muted |
| `--accent` | `oklch(0.35 0.01 240)` | Accent color (matches primary) |
| `--accent-foreground` | `oklch(0.97 0.002 240)` | Text on accent |
| `--destructive` | `oklch(0.55 0.2 25)` | Error/delete states (warm red-orange) |
| `--destructive-foreground` | `oklch(0.97 0.002 240)` | Text on destructive |
| `--border` | `oklch(0.92 0.005 240)` | Border color |
| `--input` | `oklch(0.92 0.005 240)` | Input field backgrounds |
| `--ring` | `oklch(0.45 0.01 240)` | Focus ring color |

#### Dark Mode (`.dark` Class)
| Token | OKLCH Value | Description |
|-------|-------------|-------------|
| `--background` | `oklch(0.145 0 0)` | Dark background (near-black) |
| `--foreground` | `oklch(0.985 0 0)` | Light text (near-white) |
| `--card` | `oklch(0.145 0 0)` | Dark card backgrounds |
| `--card-foreground` | `oklch(0.985 0 0)` | Light card text |
| `--primary` | `oklch(0.985 0 0)` | Bright interactive elements |
| `--primary-foreground` | `oklch(0.205 0 0)` | Text on primary |
| `--secondary` | `oklch(0.269 0 0)` | Secondary elements |
| `--secondary-foreground` | `oklch(0.985 0 0)` | Light text on secondary |
| `--muted` | `oklch(0.269 0 0)` | Muted/disabled states |
| `--muted-foreground` | `oklch(0.708 0 0)` | Lighter muted text |
| `--accent` | `oklch(0.269 0 0)` | Accent color |
| `--accent-foreground` | `oklch(0.985 0 0)` | Light text on accent |
| `--destructive` | `oklch(0.396 0.141 25.723)` | Error state |
| `--destructive-foreground` | `oklch(0.637 0.237 25.331)` | Light error text |
| `--border` | `oklch(0.269 0 0)` | Dark border |
| `--input` | `oklch(0.269 0 0)` | Dark input backgrounds |
| `--ring` | `oklch(0.439 0 0)` | Focus ring (light gray) |

#### Special Colors
- **Streak Flame Icon**: `text-orange-500` - Fixed brand color for achievement streaks
- **Theme Toggle Icons**: Uses Lucide React `Moon` and `Sun` icons

---

## 🔤 Typography

### Font System
- **Primary Font**: `Geist` (sans-serif) - Modern, clean, technical
  - Family: "Geist", "Geist Fallback"
  - Used for: All body text, labels, UI elements
  
- **Monospace Font**: `Geist Mono` - For code and technical content
  - Family: "Geist Mono", "Geist Mono Fallback"
  - Used: Not heavily used in this interface

### Font Weights & Sizes

| Element | Size | Weight | Line Height | Notes |
|---------|------|--------|-------------|-------|
| Page Headline | `sm:text-3xl` → `lg:text-5xl` | `font-bold` (700) | `leading-tight` | Responsive scaling |
| Category Badge | `text-xs` | `font-medium` (500) | Default | `uppercase tracking-wider` for spacing |
| Body Text | `sm:text-base` → `lg:text-lg` | Regular (400) | `leading-relaxed` | Clamped to 4 lines |
| Action Button Labels | `text-xs` → `text-sm` | Regular (400) | Default | Bottom action buttons |
| Read More Link | `text-xs` → `text-sm` | `font-medium` (500) | Default | Underlined text link |
| Modal Headline | `text-5xl` → `md:text-6xl` | `font-bold` (700) | `leading-tight` | Larger in expanded view |
| Modal Body | `text-base` → `md:text-lg` | Regular (400) | `leading-relaxed` | Generous spacing |
| List Items | `text-base` → `md:text-lg` | Regular (400) | `leading-relaxed` | Within expanded modal |

### Text Effects
- **Text Balance**: Used on headlines for optimal line wrapping
- **Underline Offset**: `underline-offset-4` on "Read More" links
- **Text Opacity Variants**: 
  - Full contrast: `text-foreground`
  - Secondary: `text-foreground/80` (80% opacity)
  - Tertiary: `text-foreground/75` (75% opacity)

### Text Selection
- **Selection Behavior**: `::selection` pseudo-element styled with theme colors
- **Background**: Uses `var(--primary)` color
- **Text Color**: Uses `var(--primary-foreground)` for optimal contrast
- **Applies To**: All text content across the application
- **Compatibility**: Works with `::-moz-selection` for Firefox

---

## 🎯 Layout & Spacing

### Layout Methodology
- **Primary Method**: Flexbox (`flex`)
- **Grid Usage**: None (not needed for this linear layout)
- **Positioning**: Relative/sticky only where needed

### Spacing Scale (Using Tailwind)
| Value | Pixels | Usage |
|-------|--------|-------|
| `gap-1` | 4px | Icon-to-text spacing |
| `gap-2` | 8px | Small component gaps |
| `gap-4` | 16px | Medium spacing |
| `gap-6` | 24px | Large content gaps |
| `gap-8` | 32px | Extra large button spacing |
| `px-4` | 16px | Horizontal padding (mobile) |
| `px-6` | 24px | Horizontal padding (desktop) |
| `py-8` | 32px | Vertical padding (mobile) |
| `py-12` | 48px | Vertical padding (desktop) |
| `pt-8` | 32px | Top padding (action area) |
| `pt-16` | 64px | Top padding (content offset for navbar) |
| `pt-6` | 24px | Top padding (navbar area) |
| `mb-8` | 32px | Bottom margin (sections) |
| `mb-4` | 16px | Bottom margin (sub-sections) |
| `h-16` | 64px | Navigation bar height |

### Responsive Breakpoints
```
Mobile: < 640px  (default styles)
sm:     ≥ 640px  (small devices, tablets)
md:     ≥ 768px  (tablets, small laptops)
lg:     ≥ 1024px (laptops, desktops)
```

### Container Sizing
- **Max Content Width**: `max-w-lg` (476px)
- **Modal Max Width**: `max-w-2xl` (672px)
- **Full Screen**: `h-screen` (100vh) and `w-screen` (100vw)

---

## 🧩 Component Architecture

### Core Components

#### 1. **Navigation Bar** (`app/page.tsx`)
- **Fixed Position**: Sticky header with scroll-based visibility
- **Height**: `h-16` (64px)
- **Background**: `bg-background border-b border-border`
- **Layout**: Flex with `items-center justify-between`
- **Animation**: Smooth Y-translate (`translate-y-0` or `-translate-y-full`)
- **Padding**: `px-4 sm:px-6`

**Streak Display**:
- Icon: Lucide `Flame` (w-5 h-5) with `text-orange-500`
- Text: Font semibold, responsive sizing

**Theme Toggle**:
- Button with `p-2 rounded-lg hover:bg-muted`
- Icons: Lucide `Moon` or `Sun` (w-5 h-5)

#### 2. **Content Card** (`components/content-card.tsx`)
- **Container**: Full viewport height (`h-screen`), centered flex
- **Max Width**: `max-w-lg` for optimal reading width
- **Layout**: Vertical flex with space-between

**Top Section** (Content):
- Category badge: Uppercase, muted foreground
- Headline: Bold, responsive scaling
- Preview text: Clamped to 4 lines (`line-clamp-4`)
- Action Links: "Read More →" and "Fullscreen →" side by side, underlined text links with hover state

**Bottom Section** (Actions):
- Three action buttons: Save, Like, Share
- Layout: Horizontal flex with `gap-6 sm:gap-8`
- Button style: Icon + label flex column
- States: Fill icon when active, outline when inactive
- Icon Set: BookmarkIcon (Save), Heart (Like), Share2 (Share)

#### 3. **Expanded Modal** (`components/expanded-modal.tsx`)
- **Backdrop**: `bg-background/95 backdrop-blur-sm`
- **Sticky Header**: Close button with scrolling
- **Content Area**: `max-w-2xl mx-auto px-6 py-12`
- **Text Rendering**: Parsed paragraph blocks with special handling for bullet lists

**Content Structure**:
- Category badge (top)
- Large headline
- Expanded content paragraphs with generous spacing
- Bullet lists within sections

#### 4. **Fullscreen Content** (`components/fullscreen-content.tsx`)
- **Trigger**: "Fullscreen →" text link on content cards (next to "Read More")
- **Layout**: Full-screen snap-scroll presentation matching feed style
- **Header**: Sticky bar with streak counter (left), action buttons (right: Save, Like, Share, Close X)
- **Streak Display**: Shows current streak count in header left side with flame icon
- **Navigation**: 
  - Scroll down to next post (auto-snap when velocity drops near snap point)
  - Scroll up to previous post (same auto-snap behavior)
  - Pressing ESC or clicking X button closes and returns to feed
- **Content Area**: Full viewport height (h-screen) with centered max-width container (max-w-2xl)
- **Expanded Text**: Full article content with expanded paragraphs, bullet lists, and generous spacing
- **Indicators**: 
  - "You've reached the end" message at last post with scroll-up prompt
  - "Beginning of content" message at first post with scroll-down prompt
- **State Sync**: Like/Save/Share states persist between feed and fullscreen views, updates reflect in both modes

#### 5. **Theme Provider** (`components/theme-provider.tsx`)
- Wraps application with `next-themes` library
- Attributes: `class` (applies dark class to html element)
- Default theme: `light`
- System detection: `enableSystem={true}`

---

## 🔧 Technical Details

### Next.js Configuration
- **Version**: 16.1.6
- **App Router**: Yes (using `/app` directory)
- **Fonts**: Geist (imported from `next/font/google`)
- **Analytics**: Vercel Analytics integrated

### Tailwind CSS Configuration
- **Version**: 4.2.0
- **Framework**: Latest with `@tailwindcss/postcss`
- **Custom Configuration**: Via `@theme` inline in globals.css
- **Radius**: `--radius: 0.375rem` (6px)

### Border Styling
- **Card Borders**: Removed from content cards for seamless aesthetic (`.border-border` class removed)
- **Modal/Header Borders**: Strategic use of `border-b border-border` for visual separation in sticky headers
- **Border Color**: Defined by `--border` CSS variable (oklch values)
- **Minimal Approach**: Only borders where necessary for functional clarity

### CSS Custom Properties (Design Tokens)
All colors are defined as CSS variables in `:root` (light mode) and `.dark` (dark mode) with oklch values.

### State Management
- **Theme**: `next-themes` hook (client-side)
- **Content State**: React useState (in-memory)
- **Scroll Position**: useRef for scroll tracking

### Animations & Transitions
- **Scroll Detection**: Smooth auto-snap between pages
- **Bar Hide/Show**: 300ms ease-in-out transition
- **Button Hover**: Color transitions on interactions
- **Modal Overlay**: Blur and opacity effects

---

## 📱 Responsive Design

### Breakpoint Strategy
1. **Mobile First**: Default styles for small screens
2. **Small Devices** (`sm:`): Tablets (≥640px)
3. **Medium** (`md:`): Small laptops (≥768px)
4. **Large** (`lg:`): Desktops (≥1024px)

### Key Responsive Changes
| Element | Mobile | sm | md | lg |
|---------|--------|----|----|-----|
| Headline | 3xl | 3xl | 4xl | 5xl |
| Body Text | sm | base | base | lg |
| Horizontal Padding | px-4 | px-6 | px-6 | px-6 |
| Vertical Padding | py-8 | py-12 | py-12 | py-12 |
| Button Gap | gap-6 | gap-8 | gap-8 | gap-8 |
| Modal Headline | 5xl | 5xl | 6xl | 6xl |
| Modal Body | base | base | lg | lg |

---

## 🎬 Interaction Patterns

### Scrollbar Styling
- **Hidden Scrollbars**: Complete scrollbar hiding across all browsers while maintaining full scroll functionality
- **CSS Rules Applied To**: `html`, `body`, and all `div` elements
- **WebKit Browsers** (Chrome, Safari, Edge): `::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; }`
- **Firefox**: `scrollbar-width: none;`
- **Internet Explorer/Edge Legacy**: `-ms-overflow-style: none;`
- **Fallback**: Combined approach using both CSS properties and !important flags to override browser defaults

### Scroll Behavior
- **Snap Type**: `snap-y snap-mandatory` (full-page vertical snapping)
- **Snap Alignment**: `snap-start` on each content section
- **Auto-scroll**: Triggered when scrolling slows near snap points
- **Smooth Scroll**: `scroll-behavior: smooth` for programmatic scrolls
- **Passive Listeners**: Scroll events use `{ passive: true }` for performance

### Button Interactions

**Action Buttons**:
```
Normal State: Icon outline + muted foreground
Hover State: Icon fills, text darkens
Active State: Icon filled permanently
```

**Theme Toggle**:
```
Hover: bg-muted background appears
Click: Theme switches (light ↔ dark)
```

**Navigation Bar**:
```
Scroll Down (velocity > 10px): Slides up with -translate-y-full
Scroll Up (velocity < -10px): Slides down with translate-y-0
```

### Expanded Modal Behavior
- **Trigger**: "Read More" button click
- **Keyboard**: ESC key closes and returns to feed
- **Body Lock**: `document.body.style.overflow = 'hidden'` when open
- **Backdrop**: Click outside doesn't close (no event listener)
- **Content**: Displays full expanded article text with parsed sections and bullet lists

### Fullscreen Mode Behavior
- **Trigger**: "Fullscreen →" text link click
- **Keyboard**: ESC key closes and returns to feed
- **Body Lock**: `document.body.style.overflow = 'hidden'` when open
- **Navigation**: Mandatory vertical snap-scroll between posts
- **Auto-Scroll**: Automatically snaps to next/previous post when scroll velocity drops below threshold
- **State Sync**: All action button states (Like, Save) reflected immediately in both feed and fullscreen
- **Close Button**: X button in top-right of header returns to feed

---

## 🚀 Performance Optimizations

### Client Components
- Minimal re-renders using proper dependency arrays
- Passive event listeners for scroll performance
- State updates batched appropriately

### CSS & Styling
- Tailwind CSS purges unused styles in production
- Custom properties enable efficient theme switching
- No extra layers or complex selectors

### Code Splitting
- Theme provider isolated in separate component
- Modal component lazy-loadable if needed
- Icon library (lucide-react) tree-shakable

---

## 📦 Dependencies

### Core Framework
- `next`: 16.1.6 - React framework
- `react`: 19.2.4 - UI library
- `react-dom`: 19.2.4 - DOM rendering

### Styling
- `tailwindcss`: 4.2.0 - Utility-first CSS
- `@tailwindcss/postcss`: 4.2.0 - PostCSS plugin
- `postcss`: 8.5+ - CSS transformation
- `autoprefixer`: 10.4.20 - Vendor prefixes

### UI & Theme
- `next-themes`: 0.4.6 - Theme switching
- `lucide-react`: 0.564.0 - Icon library (Flame, Sun, Moon, Bookmark, Heart, Share2, X)
- `shadcn/ui`: Component library infrastructure

### Utilities
- `clsx`: 2.1.1 - Conditional className merging
- `tailwind-merge`: 3.3.1 - Tailwind class conflict resolution
- `class-variance-authority`: 0.7.1 - Component variant system

### Deployment & Analytics
- `@vercel/analytics`: 1.6.1 - Performance metrics

---

## 🎯 Design Principles

1. **Minimalism**: Clean, whitespace-respecting design
2. **Readability**: High contrast, proper typography hierarchy
3. **Responsiveness**: Works seamlessly across all devices
4. **Accessibility**: Semantic HTML, ARIA labels, keyboard navigation
5. **Performance**: Optimized animations and transitions
6. **Consistency**: Unified color system and spacing scale
7. **User-Centric**: Fast interactions, smooth scrolling, clear affordances

---

## 🔄 Theme Switching

### Implementation
- Uses `next-themes` library with dark mode detection
- Theme applied to `<html>` element via `class` attribute
- CSS variables automatically update based on `.dark` selector
- System preference respected with `enableSystem={true}`

### Dark Mode Colors
All variables redefine in `.dark` class with appropriate oklch values:
- Backgrounds become darker (oklch(0.145 0 0))
- Foreground becomes lighter (oklch(0.985 0 0))
- Accents maintain visual hierarchy with adjusted lightness

---

## 📋 File Structure

```
/vercel/share/v0-project/
├── app/
│   ├── layout.tsx           # Root layout with theme provider & hydration fixes
│   ├── page.tsx             # Main feed with content, scroll logic & fullscreen handler
│   └── globals.css          # Global styles, design tokens, scrollbar hiding, text selection
├── components/
│   ├── content-card.tsx     # Individual card component with Expand button
│   ├── expanded-modal.tsx   # Modal for "Read More" content view
│   ├── fullscreen-content.tsx # Fullscreen post view with auto-scrolling & indicators
│   ├── theme-provider.tsx   # Theme wrapper with next-themes
│   └── ui/                  # Radix UI component library
├── public/                  # Static assets & icons
├── package.json             # Dependencies & scripts
├── tsconfig.json            # TypeScript configuration
└── README.md                # This file (complete design documentation)
```

---

## 🚀 Getting Started

### Installation
```bash
# Install dependencies
npm install
# or
pnpm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

### Development
- Server runs on `localhost:3000`
- Hot Module Replacement (HMR) enabled
- CSS changes reflect instantly
- Theme changes apply in real-time

### Production Build
- Optimized bundle with tree-shaking
- Tailwind CSS purged of unused styles
- Analytics integrated
- Vercel deployment ready

---

## 🎨 Reproduction Guide

To recreate this exact UI design on any system:

1. **Set Color Variables**: Copy all oklch values from the Light/Dark Mode sections
2. **Apply Typography**: Use Geist and Geist Mono fonts with specified weights
3. **Implement Spacing**: Use the spacing scale values for consistent gaps/padding
4. **Add Components**: Build content card and modal following the component architecture
5. **Enable Theme Switching**: Implement next-themes library or equivalent
6. **Add Animations**: Apply scroll detection and smooth transitions as specified
7. **Test Responsiveness**: Verify all breakpoints match the responsive design table

---

## 📝 Notes

- The streak counter increments on likes (feature for engagement tracking)
- Scroll behavior uses snap-mandatory for full-page presentation
- Theme detection respects system preferences on first load
- All interactive elements have hover states for better UX
- Icons are from Lucide React (24px default, 28px for close button)
- The design supports both light and dark modes automatically

---

## 🐛 Fixed Issues

- **Hydration Mismatch**: Added `suppressHydrationWarning={true}` to both `<html>` and `<body>` tags to resolve server/client rendering conflicts with theme provider applying dark/light mode classes
- **Scrollbar Visibility on All Browsers**: Applied aggressive CSS rules to `html`, `body`, and `div` elements with `!important` flags to hide scrollbars in Chrome, Firefox, Safari, Edge while maintaining full scroll functionality
- **Text Selection**: Added theme-aware text selection styling with `::selection` and `::-moz-selection` pseudo-elements matching primary color
- **Border Visibility**: Removed unnecessary `border-border` class from base element styles for seamless, clean aesthetic
- **Fullscreen Navigation**: Implemented snap-scroll with auto-snapping to next/previous post when velocity drops, boundary indicators at start/end
- **Fullscreen Button Positioning**: Repositioned from bottom action bar to top text links ("Read More →" and "Fullscreen →") matching "Read More" interaction pattern
- **Action Buttons in Fullscreen**: Save, Like, Share buttons with persistent state in sticky header (right side), Streak counter in header (left side)
- **State Persistence**: Like/Save states sync seamlessly between feed view and fullscreen view, updates reflect in both modes immediately
- **Keyboard Navigation**: ESC key closes fullscreen and returns to feed; keyboard event properly bound with dependency array

---

## 🎯 Reproduction Checklist

When recreating this design:

1. **Scrollbars**: Implement CSS rules for hidden scrollbars across all browsers
2. **Borders**: Remove card borders (`border-border` class) for seamless aesthetic
3. **Text Selection**: Style `::selection` with primary color and primary-foreground
4. **Content Cards**: Include Save, Like, Share, and Expand buttons
5. **Fullscreen Mode**: Create separate full-screen view with auto-scrolling navigation
6. **Indicators**: Add "reached end" and "beginning" messages at boundaries
7. **State Sync**: Ensure Like/Save states persist between views
8. **Keyboard**: Implement ESC to close fullscreen
9. **Snap Points**: Use mandatory snap-scroll for smooth full-page navigation
10. **Theme Colors**: Apply oklch values for perfect color consistency

**Last Updated**: March 11, 2026 (v2.0 - Fullscreen Mode)
**Framework Version**: Next.js 16.1.6 | React 19.2.4 | Tailwind CSS 4.2.0  
**Status**: Production Ready ✓
**Features**: Feed Scrolling • Fullscreen Viewing • Smart Navigation • Theme Aware Selection • Borderless Design • Streak Tracking
