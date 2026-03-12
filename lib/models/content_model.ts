/**
 * Core Data Models - Language agnostic
 * These models are designed to be easily translated to Flutter/Dart
 */

export interface ContentItem {
  id: number;
  category: string;
  headline: string;
  content: string;
  expandedContent: string;
  saved: boolean;
  liked: boolean;
  shared: boolean;
  likeCount: number;
  saveCount: number;
}

export interface UserEngagement {
  contentId: number;
  liked: boolean;
  saved: boolean;
  shared: boolean;
}

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  streakCount: number;
  totalLikes: number;
  totalSaves: number;
}

export interface AppState {
  content: ContentItem[];
  selectedContent: ContentItem | null;
  isModalOpen: boolean;
  isFullscreenOpen: boolean;
  fullscreenIndex: number;
  currentTheme: 'light' | 'dark';
  userProfile: UserProfile | null;
  streak: number;
}

export interface NavigationParams {
  cardIndex?: number;
  articleId?: number;
}

export interface ModalState {
  isOpen: boolean;
  content: ContentItem | null;
}

export interface FullscreenState {
  isOpen: boolean;
  currentIndex: number;
  content: ContentItem[];
}

// Enum for Content Categories (for type safety)
export enum ContentCategory {
  PSYCHOLOGY = 'Psychology',
  NEUROSCIENCE = 'Neuroscience',
  BEHAVIORAL_SCIENCE = 'Behavioral Science',
  COGNITIVE_SCIENCE = 'Cognitive Science',
  PHILOSOPHY = 'Philosophy',
  TECHNOLOGY = 'Technology',
  ECOLOGY = 'Ecology',
  ECONOMICS = 'Economics',
}

// Enum for Theme
export enum Theme {
  LIGHT = 'light',
  DARK = 'dark',
  SYSTEM = 'system',
}

// ============================================================================
// ADMIN FEATURE MODELS - Added for role-based content creation
// ============================================================================

export enum IdeaFormMode {
  JSON = 'json',
  FIELDS = 'fields',
}

export enum IdeaStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
}

/**
 * Idea data structure for admin-created content
 * Maps to the ideas table in the database
 */
export interface Idea {
  id: string
  category: string
  title: string
  explanation: string
  example: string
  takeaway: string
  customHeading?: string
  customContent?: string
  
  // Engagement metrics
  likesCount: number
  savesCount: number
  shareCount: number
  commentsCount: number
  
  // Publishing & Metadata
  status: IdeaStatus
  createdBy: string
  createdOn: Date
  publishedOn?: Date
  modifiedOn: Date
}

/**
 * Admin input for creating/editing ideas
 * This is what the admin form submits
 */
export interface AdminIdeaInput {
  category: string
  title: string
  explanation: string
  example: string
  takeaway: string
  customHeading?: string
  customContent?: string
  status: IdeaStatus
}

/**
 * JSON representation of AdminIdeaInput for JSON mode editor
 */
export interface AdminIdeaJSON {
  category: string
  title: string
  explanation: string
  example: string
  takeaway: string
  customHeading?: string
  customContent?: string
  status: string
}

/**
 * Validation errors for idea input
 */
export interface IdeaValidationError {
  field: keyof AdminIdeaInput
  message: string
}

/**
 * Response from admin service operations
 */
export interface AdminActionResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  errors?: IdeaValidationError[]
}

/**
 * Form submission payload
 */
export interface IdeaFormSubmission {
  input: AdminIdeaInput
  mode: IdeaFormMode
  rawJSON?: string
}

/**
 * Constants for categories (extended from existing)
 */
export const IDEA_CATEGORIES = [
  'Psychology',
  'Neuroscience',
  'Behavioral Science',
  'Cognitive Science',
  'Philosophy',
  'Technology',
  'Ecology',
  'Economics',
  'Other',
] as const

export type IdeaCategory = (typeof IDEA_CATEGORIES)[number]
