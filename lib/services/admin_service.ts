/**
 * Admin Service Layer
 * 
 * Handles all admin-specific business logic including:
 * - Idea creation and publishing
 * - Data validation
 * - JSON parsing
 * 
 * This service is designed to be cross-platform compatible
 */

import {
  AdminIdeaInput,
  AdminActionResponse,
  IdeaValidationError,
  Idea,
  IdeaStatus,
  AdminIdeaJSON,
  IDEA_CATEGORIES,
} from '@/lib/models/content_model'
import AuthService from '@/lib/services/auth_service'

/**
 * Validates admin idea input
 * @param input - The idea input to validate
 * @returns Array of validation errors (empty if valid)
 */
export function validateIdeaInput(
  input: AdminIdeaInput,
): IdeaValidationError[] {
  const errors: IdeaValidationError[] = []

  // Validate category
  if (!input.category || input.category.trim().length === 0) {
    errors.push({
      field: 'category',
      message: 'Category is required',
    })
  } else if (!IDEA_CATEGORIES.includes(input.category as any)) {
    errors.push({
      field: 'category',
      message: `Category must be one of: ${IDEA_CATEGORIES.join(', ')}`,
    })
  }

  // Validate title
  if (!input.title || input.title.trim().length === 0) {
    errors.push({
      field: 'title',
      message: 'Title is required',
    })
  } else if (input.title.length > 200) {
    errors.push({
      field: 'title',
      message: 'Title must be less than 200 characters',
    })
  }

  // Validate explanation
  if (!input.explanation || input.explanation.trim().length === 0) {
    errors.push({
      field: 'explanation',
      message: 'Explanation is required',
    })
  } else if (input.explanation.length < 20) {
    errors.push({
      field: 'explanation',
      message: 'Explanation must be at least 20 characters',
    })
  }

  // Validate example
  if (!input.example || input.example.trim().length === 0) {
    errors.push({
      field: 'example',
      message: 'Example is required',
    })
  } else if (input.example.length < 20) {
    errors.push({
      field: 'example',
      message: 'Example must be at least 20 characters',
    })
  }

  // Validate takeaway
  if (!input.takeaway || input.takeaway.trim().length === 0) {
    errors.push({
      field: 'takeaway',
      message: 'Takeaway is required',
    })
  } else if (input.takeaway.length < 10) {
    errors.push({
      field: 'takeaway',
      message: 'Takeaway must be at least 10 characters',
    })
  }

  // Validate status
  if (!input.status || !Object.values(IdeaStatus).includes(input.status)) {
    errors.push({
      field: 'status',
      message: 'Invalid status',
    })
  }

  // Optional: custom_heading and custom_content can be empty
  if (input.customHeading && input.customHeading.length > 200) {
    errors.push({
      field: 'customHeading',
      message: 'Custom heading must be less than 200 characters',
    })
  }

  return errors
}

/**
 * Parses JSON string into AdminIdeaInput
 * @param jsonString - The JSON string to parse
 * @returns Object with parsed input or error
 */
export function parseJSONInput(
  jsonString: string,
): AdminActionResponse<AdminIdeaInput> {
  try {
    const parsed = JSON.parse(jsonString)

    // Basic type checking
    if (typeof parsed !== 'object' || parsed === null) {
      return {
        success: false,
        error: 'JSON must be an object',
      }
    }

    const input: AdminIdeaInput = {
      category: parsed.category || '',
      title: parsed.title || '',
      explanation: parsed.explanation || '',
      example: parsed.example || '',
      takeaway: parsed.takeaway || '',
      customHeading: parsed.customHeading,
      customContent: parsed.customContent,
      status: parsed.status || IdeaStatus.DRAFT,
    }

    // Validate the parsed input
    const validationErrors = validateIdeaInput(input)
    if (validationErrors.length > 0) {
      return {
        success: false,
        error: 'Validation failed',
        errors: validationErrors,
      }
    }

    return {
      success: true,
      data: input,
    }
  } catch (error) {
    const message =
      error instanceof SyntaxError ? 'Invalid JSON format' : 'Parsing failed'
    return {
      success: false,
      error: message,
    }
  }
}

/**
 * Converts AdminIdeaInput to JSON string
 * @param input - The idea input to stringify
 * @returns JSON string representation
 */
export function ideaInputToJSON(input: AdminIdeaInput): string {
  const json: AdminIdeaJSON = {
    category: input.category,
    title: input.title,
    explanation: input.explanation,
    example: input.example,
    takeaway: input.takeaway,
    status: input.status,
  }

  // Only include optional fields if they have values
  if (input.customHeading) {
    json.customHeading = input.customHeading
  }
  if (input.customContent) {
    json.customContent = input.customContent
  }

  return JSON.stringify(json, null, 2)
}

/**
 * Creates a new idea (stub for database integration)
 * @param input - The idea input from the form
 * @param userId - The ID of the user creating the idea
 * @returns Response with created idea or error
 */
export async function createIdea(
  input: AdminIdeaInput,
  userId: string,
): Promise<AdminActionResponse<Idea>> {
  // Validate input
  const validationErrors = validateIdeaInput(input)
  if (validationErrors.length > 0) {
    return {
      success: false,
      error: 'Validation failed',
      errors: validationErrors,
    }
  }

  try {
    // TODO: Integrate with actual database
    // This is a mock implementation for demonstration
    const now = new Date()
    const newIdea: Idea = {
      id: `idea_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      category: input.category,
      title: input.title,
      explanation: input.explanation,
      example: input.example,
      takeaway: input.takeaway,
      customHeading: input.customHeading,
      customContent: input.customContent,
      likesCount: 0,
      savesCount: 0,
      shareCount: 0,
      commentsCount: 0,
      status: input.status,
      createdBy: userId,
      createdOn: now,
      publishedOn: input.status === IdeaStatus.PUBLISHED ? now : undefined,
      modifiedOn: now,
    }

    console.log('[AdminService] Idea created:', newIdea)

    return {
      success: true,
      data: newIdea,
    }
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to create idea',
    }
  }
}

/**
 * Publishes a draft idea
 * @param ideaId - The ID of the idea to publish
 * @returns Response with published idea or error
 */
export async function publishIdea(
  ideaId: string,
): Promise<AdminActionResponse<Idea>> {
  try {
    // TODO: Integrate with actual database
    console.log('[AdminService] Publishing idea:', ideaId)

    return {
      success: true,
      error: 'Idea published successfully',
    }
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to publish idea',
    }
  }
}

/**
 * Saves a draft idea
 * @param input - The idea input
 * @param userId - The ID of the user saving the draft
 * @returns Response with saved draft
 */
export async function saveDraft(
  input: AdminIdeaInput,
  userId: string,
): Promise<AdminActionResponse<Idea>> {
  const draftInput: AdminIdeaInput = {
    ...input,
    status: IdeaStatus.DRAFT,
  }

  return createIdea(draftInput, userId)
}

/**
 * Gets current user's role from auth service
 * @returns User role ('admin', 'moderator', or 'user')
 */
export function getCurrentUserRole(): string {
  const user = AuthService.getCurrentUser()
  return user?.role || 'user'
}

/**
 * Check if current user is admin
 * @returns true if user is admin
 */
export function isCurrentUserAdmin(): boolean {
  return getCurrentUserRole() === 'admin'
}
