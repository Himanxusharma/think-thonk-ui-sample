/**
 * Utility Helper Functions
 * Common functions used across the app
 */

import { breakpoints } from '@/lib/constants/app_constants';

/**
 * Format large numbers with K, M notation
 * @param num - Number to format
 * @returns Formatted string
 * @example formatNumber(1248) => "1.2K"
 */
export function formatNumber(num: number): string {
  if (num >= 1000000) {
    return (num / 1000000).toFixed(1) + 'M';
  }
  if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'K';
  }
  return num.toString();
}

/**
 * Truncate text to specified length with ellipsis
 * @param text - Text to truncate
 * @param length - Max length
 * @returns Truncated text
 */
export function truncateText(text: string, length: number): string {
  if (text.length <= length) return text;
  return text.substring(0, length) + '...';
}

/**
 * Debounce function to limit function calls
 * @param func - Function to debounce
 * @param wait - Wait time in milliseconds
 * @returns Debounced function
 */
export function debounce<T extends (...args: unknown[]) => unknown>(
  func: T,
  wait: number,
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout;
  return function executedFunction(...args: Parameters<T>) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

/**
 * Throttle function to limit function calls
 * @param func - Function to throttle
 * @param limit - Limit time in milliseconds
 * @returns Throttled function
 */
export function throttle<T extends (...args: unknown[]) => unknown>(
  func: T,
  limit: number,
): (...args: Parameters<T>) => void {
  let inThrottle: boolean;
  return function executedFunction(...args: Parameters<T>) {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}

/**
 * Check if device matches breakpoint
 * @param breakpoint - Breakpoint name
 * @param width - Current width (defaults to window width)
 * @returns Boolean
 */
export function matchesBreakpoint(breakpoint: keyof typeof breakpoints, width?: number): boolean {
  const currentWidth = width ?? (typeof window !== 'undefined' ? window.innerWidth : 0);
  return currentWidth >= breakpoints[breakpoint];
}

/**
 * Get current breakpoint
 * @param width - Current width
 * @returns Breakpoint name
 */
export function getCurrentBreakpoint(width: number): keyof typeof breakpoints {
  if (width >= breakpoints.xl) return 'xl';
  if (width >= breakpoints.lg) return 'lg';
  if (width >= breakpoints.md) return 'md';
  if (width >= breakpoints.sm) return 'sm';
  return 'mobile';
}

/**
 * Calculate scroll velocity
 * @param startY - Starting Y position
 * @param endY - Ending Y position
 * @param timeMs - Time elapsed in milliseconds
 * @returns Velocity in pixels per millisecond
 */
export function calculateScrollVelocity(startY: number, endY: number, timeMs: number): number {
  if (timeMs === 0) return 0;
  return Math.abs(endY - startY) / timeMs;
}

/**
 * Handle share API with error handling
 * @param title - Share title
 * @param text - Share text
 * @returns Promise<boolean> - Success status
 */
export async function handleShare(title: string, text: string): Promise<boolean> {
  if (!navigator.share) {
    console.warn('Share API not available');
    return false;
  }

  try {
    await navigator.share({
      title,
      text,
    });
    return true;
  } catch (err: unknown) {
    if (err instanceof Error && err.name === 'AbortError') {
      // User cancelled share
      return false;
    }
    // Silently handle permission denied and other errors
    return false;
  }
}

/**
 * Format date to readable string
 * @param date - Date object or timestamp
 * @returns Formatted date string
 */
export function formatDate(date: Date | number): string {
  const dateObj = typeof date === 'number' ? new Date(date) : date;
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(dateObj);
}

/**
 * Generate unique ID
 * @returns Unique ID string
 */
export function generateId(): string {
  return Math.random().toString(36).substr(2, 9) + Date.now().toString(36);
}

/**
 * Deep clone object
 * @param obj - Object to clone
 * @returns Cloned object
 */
export function deepClone<T>(obj: T): T {
  return JSON.parse(JSON.stringify(obj));
}

/**
 * Check if object is empty
 * @param obj - Object to check
 * @returns Boolean
 */
export function isEmpty(obj: Record<string, unknown>): boolean {
  return Object.keys(obj).length === 0;
}

/**
 * Merge objects deeply
 * @param target - Target object
 * @param source - Source object
 * @returns Merged object
 */
export function mergeDeep<T extends Record<string, unknown>>(target: T, source: T): T {
  const result = { ...target };
  for (const key in source) {
    if (source[key] instanceof Object && !Array.isArray(source[key])) {
      result[key] = mergeDeep(target[key] as T, source[key] as T);
    } else {
      result[key] = source[key];
    }
  }
  return result;
}
