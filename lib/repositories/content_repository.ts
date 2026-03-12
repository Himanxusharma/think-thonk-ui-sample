/**
 * Content Repository - Data Access Layer
 * Handles fetching and managing content data
 * This layer abstracts data source (hardcoded, API, database, etc.)
 */

import { ContentItem } from '@/lib/models/content_model';

// Mock data - In production, this would come from an API or database
const MOCK_CONTENT: ContentItem[] = [
  {
    id: 1,
    category: 'Psychology',
    headline: 'The Horse Effect Theory',
    content:
      'Understanding how our brains process information through metaphorical thinking. A breakthrough study reveals patterns in how successful individuals visualize complex problems. Research shows this technique increases problem-solving efficiency by up to 47%.',
    expandedContent: `Understanding how our brains process information through metaphorical thinking has revolutionized modern psychology. A breakthrough study reveals patterns in how successful individuals visualize complex problems using animal-based metaphors.

Research conducted over 18 months at leading universities shows this technique increases problem-solving efficiency by up to 47%. The methodology involves teaching participants to think of challenges as if they were a horse—strong, focused, and moving forward.

Key findings include:
- Enhanced cognitive flexibility
- Improved stress management
- Better long-term memory retention
- Increased creative output in professional settings

The implications are far-reaching, suggesting that our ancient relationship with animals has shaped our cognitive architecture in ways we're only beginning to understand. This opens new avenues for therapeutic interventions and educational methodologies.`,
    saved: false,
    liked: false,
    shared: false,
    likeCount: 1248,
    saveCount: 542,
  },
  {
    id: 2,
    category: 'Neuroscience',
    headline: 'Brain Plasticity in Adults',
    content:
      'New research challenges the long-held belief that adult brains cannot form new neural pathways. Scientists have discovered remarkable regenerative capabilities even in older individuals. This discovery has profound implications for treating neurological conditions.',
    expandedContent: `The human brain, long thought to be "fixed" after early childhood, exhibits remarkable plasticity throughout life. New research challenges the long-held belief that adult brains cannot form new neural pathways or recover from damage.

Scientists from multiple institutions have discovered remarkable regenerative capabilities even in individuals over 60 years old. Using advanced imaging techniques, researchers tracked the formation of new neurons and synapses in response to learning and experience.

Key breakthroughs:
- Adult neurogenesis occurs in the hippocampus
- Environmental enrichment stimulates neural growth
- Learning new skills at any age creates structural changes
- Recovery from stroke is possible with proper rehabilitation

This discovery has profound implications for treating neurological conditions like Alzheimer's, Parkinson's, and traumatic brain injuries. It fundamentally changes how we approach aging and cognitive decline, suggesting that the brain retains the ability to rewire itself when properly stimulated.`,
    saved: false,
    liked: false,
    shared: false,
    likeCount: 892,
    saveCount: 367,
  },
  // Add remaining items here...
];

class ContentRepository {
  /**
   * Fetch all content
   * @returns Promise<ContentItem[]>
   */
  static async getAllContent(): Promise<ContentItem[]> {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 300));
    return MOCK_CONTENT;
  }

  /**
   * Fetch single content by ID
   * @param id - Content ID
   * @returns Promise<ContentItem | null>
   */
  static async getContentById(id: number): Promise<ContentItem | null> {
    await new Promise(resolve => setTimeout(resolve, 100));
    return MOCK_CONTENT.find(item => item.id === id) || null;
  }

  /**
   * Fetch content by category
   * @param category - Category name
   * @returns Promise<ContentItem[]>
   */
  static async getContentByCategory(category: string): Promise<ContentItem[]> {
    await new Promise(resolve => setTimeout(resolve, 200));
    return MOCK_CONTENT.filter(item => item.category === category);
  }

  /**
   * Update content item
   * @param id - Content ID
   * @param updates - Partial updates
   * @returns Promise<ContentItem | null>
   */
  static async updateContent(id: number, updates: Partial<ContentItem>): Promise<ContentItem | null> {
    await new Promise(resolve => setTimeout(resolve, 150));
    const index = MOCK_CONTENT.findIndex(item => item.id === id);
    if (index === -1) return null;

    MOCK_CONTENT[index] = { ...MOCK_CONTENT[index], ...updates };
    return MOCK_CONTENT[index];
  }

  /**
   * Save user engagement (like/save)
   * @param contentId - Content ID
   * @param liked - Like status
   * @param saved - Save status
   * @returns Promise<boolean>
   */
  static async saveEngagement(
    contentId: number,
    liked: boolean,
    saved: boolean,
  ): Promise<boolean> {
    try {
      await new Promise(resolve => setTimeout(resolve, 200));
      const content = await this.getContentById(contentId);
      if (content) {
        await this.updateContent(contentId, { liked, saved });
        return true;
      }
      return false;
    } catch (error) {
      console.error('Error saving engagement:', error);
      return false;
    }
  }

  /**
   * Fetch user's saved content
   * @returns Promise<ContentItem[]>
   */
  static async getSavedContent(): Promise<ContentItem[]> {
    await new Promise(resolve => setTimeout(resolve, 300));
    return MOCK_CONTENT.filter(item => item.saved);
  }

  /**
   * Fetch user's liked content
   * @returns Promise<ContentItem[]>
   */
  static async getLikedContent(): Promise<ContentItem[]> {
    await new Promise(resolve => setTimeout(resolve, 300));
    return MOCK_CONTENT.filter(item => item.liked);
  }
}

export default ContentRepository;
