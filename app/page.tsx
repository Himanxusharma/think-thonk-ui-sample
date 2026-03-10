'use client'

import { useState, useEffect } from 'react'
import ContentCard from '@/components/content-card'
import ExpandedModal from '@/components/expanded-modal'

interface ContentItem {
  id: number
  category: string
  headline: string
  content: string
  expandedContent: string
  saved?: boolean
  liked?: boolean
  shared?: boolean
}

const SAMPLE_CONTENT: ContentItem[] = [
  {
    id: 1,
    category: 'Psychology',
    headline: 'The Horse Effect Theory',
    content: 'Understanding how our brains process information through metaphorical thinking. A breakthrough study reveals patterns in how successful individuals visualize complex problems. Research shows this technique increases problem-solving efficiency by up to 47%.',
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
  },
  {
    id: 2,
    category: 'Neuroscience',
    headline: 'Brain Plasticity in Adults',
    content: 'New research challenges the long-held belief that adult brains cannot form new neural pathways. Scientists have discovered remarkable regenerative capabilities even in older individuals. This discovery has profound implications for treating neurological conditions.',
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
  },
  {
    id: 3,
    category: 'Behavioral Science',
    headline: 'The Paradox of Choice',
    content: 'Why having more options often leads to less satisfaction and increased anxiety. This psychological phenomenon affects everything from consumer behavior to career decisions. Understanding it can improve decision-making quality.',
    expandedContent: `In an age of unprecedented abundance, we face a peculiar problem: having more options often leads to less satisfaction rather than more. This counterintuitive phenomenon, known as the Paradox of Choice, affects everything from consumer behavior to career decisions.

Pioneering research shows that while some choice is good, too much choice can be paralyzing. When faced with numerous options, people experience:
- Increased decision fatigue
- Higher anxiety and regret
- Analysis paralysis
- Reduced satisfaction with final choices

Real-world applications reveal striking patterns:
- Supermarkets with 40 jam varieties sell less than those with 4 varieties
- Career dissatisfaction peaks in markets with unlimited job options
- Dating app users report lower satisfaction than those with limited choices

Understanding this paradox enables us to design better systems—both for ourselves and organizations. By strategically limiting options and creating decision frameworks, we can improve outcomes and increase happiness.`,
    saved: false,
    liked: false,
    shared: false,
  },
  {
    id: 4,
    category: 'Cognitive Science',
    headline: 'Memory Encoding and Recall',
    content: 'How the brain stores and retrieves information, and why some memories stick while others fade. Techniques for improving memory retention and encoding new information effectively. Practical strategies for students and professionals.',
    expandedContent: `Memory is not a recording device but a reconstructive process. Understanding how the brain encodes, stores, and retrieves information reveals why some memories stick vividly while others fade almost immediately.

The process involves three critical stages:

Encoding: How information enters memory
- Attention plays a crucial role
- Semantic processing creates stronger memories
- Elaboration links new information to existing knowledge

Storage: The consolidation of memories
- Short-term memory holds limited information
- Long-term memory requires neural changes
- Sleep consolidates memories into long-term storage

Retrieval: Accessing stored information
- Context clues trigger memory recall
- Reconstruction involves piecing together fragments
- Interference can disrupt retrieval

Practical memory improvement techniques:
- Spaced repetition strengthens neural pathways
- Mnemonics create memorable associations
- Active recall testing improves retention
- Sleep optimization enhances consolidation

By understanding these mechanisms, students and professionals can implement evidence-based strategies to remember more effectively.`,
    saved: false,
    liked: false,
    shared: false,
  },
]

export default function Home() {
  const [mounted, setMounted] = useState(false)
  const [content, setContent] = useState<ContentItem[]>(SAMPLE_CONTENT)
  const [selectedContent, setSelectedContent] = useState<ContentItem | null>(null)
  const [isModalOpen, setIsModalOpen] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const handleSave = (id: number) => {
    setContent(content.map(item =>
      item.id === id ? { ...item, saved: !item.saved } : item
    ))
  }

  const handleLike = (id: number) => {
    setContent(content.map(item =>
      item.id === id ? { ...item, liked: !item.liked } : item
    ))
  }

  const handleShare = (id: number) => {
    if (navigator.share) {
      navigator.share({
        title: content.find(item => item.id === id)?.headline,
        text: content.find(item => item.id === id)?.content,
      })
    }
  }

  const handleReadMore = (item: ContentItem) => {
    setSelectedContent(item)
    setIsModalOpen(true)
  }

  if (!mounted) {
    return null
  }

  return (
    <main className="h-screen w-screen bg-background overflow-hidden flex flex-col">
      {/* Content Feed */}
      <div className="flex-1 overflow-y-scroll snap-y snap-mandatory">
        {content.map((item) => (
          <div key={item.id} className="snap-start h-screen w-screen flex items-center justify-center">
            <ContentCard
              item={item}
              onReadMore={() => handleReadMore(item)}
              onSave={() => handleSave(item.id)}
              onLike={() => handleLike(item.id)}
              onShare={() => handleShare(item.id)}
            />
          </div>
        ))}
      </div>

      {/* Expanded Modal */}
      {selectedContent && (
        <ExpandedModal
          isOpen={isModalOpen}
          onClose={() => setIsModalOpen(false)}
          content={selectedContent}
        />
      )}
    </main>
  )
}
