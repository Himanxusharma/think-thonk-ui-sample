# Think-Thonk UI - Content Feed Application

A modern, minimalist content discovery feed with smooth full-page scrolling, built with Next.js 16, React 19, and Tailwind CSS 4. This is a professional design system documentation for perfect UI reproduction.

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
- "Read More" button: Underlined link with hover state

**Bottom Section** (Actions):
- Three action buttons: Save, Like, Share
- Layout: Horizontal flex with `gap-6 sm:gap-8`
- Button style: Icon + label flex column
- States: Fill icon when active, outline when inactive

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

#### 4. **Theme Provider** (`components/theme-provider.tsx`)
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

### Scroll Behavior
- **Snap Type**: `snap-y snap-mandatory` (full-page vertical snapping)
- **Snap Alignment**: `snap-start` on each content section
- **Auto-scroll**: Triggered when scrolling slows near snap points
- **Smooth Scroll**: `scroll-behavior: smooth` for programmatic scrolls

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

### Modal Behavior
- **Trigger**: "Read More" button click
- **Keyboard**: ESC key closes
- **Body Lock**: `document.body.style.overflow = 'hidden'` when open
- **Backdrop**: Click outside doesn't close (no event listener)

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
│   ├── layout.tsx           # Root layout with theme provider
│   ├── page.tsx             # Main feed with content & scroll logic
│   └── globals.css          # Global styles & design tokens
├── components/
│   ├── content-card.tsx     # Individual card component
│   ├── expanded-modal.tsx   # Full content modal
│   ├── theme-provider.tsx   # Theme wrapper
│   └── ui/                  # Radix UI component library
├── public/                  # Static assets & icons
├── package.json             # Dependencies & scripts
├── tsconfig.json            # TypeScript configuration
└── tailwind.config.js       # (Implicit - configured in globals.css)
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

- **Hydration Mismatch**: Added `suppressHydrationWarning={true}` to both `<html>` and `<body>` tags to resolve server/client rendering conflicts with the theme provider

---

**Last Updated**: March 11, 2026  
**Framework Version**: Next.js 16.1.6 | React 19.2.4 | Tailwind CSS 4.2.0  
**Status**: Production Ready ✓
