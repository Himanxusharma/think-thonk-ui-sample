// Color Palette - OKLCH Color Space
export const colors = {
  // Light Mode
  light: {
    background: 'oklch(0.98 0.002 240)',
    foreground: 'oklch(0.15 0.01 240)',
    card: 'oklch(0.97 0.002 240)',
    cardForeground: 'oklch(0.15 0.01 240)',
    primary: 'oklch(0.35 0.01 240)',
    primaryForeground: 'oklch(0.97 0.002 240)',
    secondary: 'oklch(0.65 0.01 240)',
    secondaryForeground: 'oklch(0.15 0.01 240)',
    muted: 'oklch(0.88 0.005 240)',
    mutedForeground: 'oklch(0.45 0.01 240)',
    accent: 'oklch(0.35 0.01 240)',
    accentForeground: 'oklch(0.97 0.002 240)',
    destructive: 'oklch(0.55 0.2 25)',
    destructiveForeground: 'oklch(0.97 0.002 240)',
    border: 'oklch(0.92 0.005 240)',
    input: 'oklch(0.92 0.005 240)',
    ring: 'oklch(0.45 0.01 240)',
    likeRed: '#ef4444', // red-500
  },

  // Dark Mode
  dark: {
    background: 'oklch(0.145 0 0)',
    foreground: 'oklch(0.985 0 0)',
    card: 'oklch(0.145 0 0)',
    cardForeground: 'oklch(0.985 0 0)',
    primary: 'oklch(0.985 0 0)',
    primaryForeground: 'oklch(0.205 0 0)',
    secondary: 'oklch(0.269 0 0)',
    secondaryForeground: 'oklch(0.985 0 0)',
    muted: 'oklch(0.269 0 0)',
    mutedForeground: 'oklch(0.708 0 0)',
    accent: 'oklch(0.269 0 0)',
    accentForeground: 'oklch(0.985 0 0)',
    destructive: 'oklch(0.396 0.141 25.723)',
    destructiveForeground: 'oklch(0.637 0.237 25.331)',
    border: 'oklch(0.269 0 0)',
    input: 'oklch(0.269 0 0)',
    ring: 'oklch(0.439 0 0)',
    likeRed: '#ef4444',
  },
};

// Typography
export const typography = {
  fontFamily: {
    sans: "'Geist', 'Geist Fallback'",
    mono: "'Geist Mono', 'Geist Mono Fallback'",
  },
  fontSize: {
    xs: '12px', // 0.75rem
    sm: '14px', // 0.875rem
    base: '16px', // 1rem
    lg: '18px', // 1.125rem
    xl: '20px', // 1.25rem
    '2xl': '24px', // 1.5rem
    '3xl': '30px', // 1.875rem
    '4xl': '36px', // 2.25rem
    '5xl': '48px', // 3rem
    '6xl': '60px', // 3.75rem
  },
  fontWeight: {
    regular: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },
  lineHeight: {
    tight: 1.2,
    normal: 1.4,
    relaxed: 1.6,
  },
};

// Spacing (in pixels)
export const spacing = {
  0: '0px',
  1: '4px',
  2: '8px',
  4: '16px',
  6: '24px',
  8: '32px',
  12: '48px',
  16: '64px',
};

// Border Radius
export const borderRadius = {
  xs: '2px',
  sm: '4px',
  md: '6px',
  lg: '8px',
  xl: '12px',
  full: '9999px',
};

// Responsive Breakpoints (pixels)
export const breakpoints = {
  mobile: 320,
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
};

// Animation/Transition Durations (milliseconds)
export const animations = {
  fast: 150,
  normal: 300,
  slow: 500,
};

// Z-Index Scale
export const zIndex = {
  hide: -1,
  auto: 0,
  base: 0,
  navbar: 10,
  dropdown: 50,
  modal: 100,
  topmost: 1000,
};

// UI Constants
export const ui = {
  navbarHeight: 64,
  modalMaxWidth: 672,
  cardMaxWidth: 476,
  streakIncrement: 1,
  defaultStreak: 7,
  autoScrollDebounce: 500,
  autoScrollVelocityThreshold: 8,
};

// API/Share Configuration
export const config = {
  shareAbortErrorName: 'AbortError',
  defaultTheme: 'light',
  enableSystemThemeDetection: true,
};
