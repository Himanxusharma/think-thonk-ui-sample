import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_model.dart';
import '../services/content_service.dart';

/// Sample content data (same as web version)
final List<ContentItem> sampleContent = [
  ContentItem(
    id: 1,
    category: 'Psychology',
    headline: 'The Horse Effect Theory',
    content:
        'Understanding how our brains process information through metaphorical thinking. A breakthrough study reveals patterns in how successful individuals visualize complex problems. Research shows this technique increases problem-solving efficiency by up to 47%.',
    expandedContent: '''Understanding how our brains process information through metaphorical thinking has revolutionized modern psychology. A breakthrough study reveals patterns in how successful individuals visualize complex problems using animal-based metaphors.

Research conducted over 18 months at leading universities shows this technique increases problem-solving efficiency by up to 47%. The methodology involves teaching participants to think of challenges as if they were a horse—strong, focused, and moving forward.

Key findings include:
- Enhanced cognitive flexibility
- Improved stress management
- Better long-term memory retention
- Increased creative output in professional settings

The implications are far-reaching, suggesting that our ancient relationship with animals has shaped our cognitive architecture in ways we're only beginning to understand. This opens new avenues for therapeutic interventions and educational methodologies.''',
    likeCount: 1248,
    saveCount: 542,
  ),
  ContentItem(
    id: 2,
    category: 'Neuroscience',
    headline: 'Brain Plasticity in Adults',
    content:
        'New research challenges the long-held belief that adult brains cannot form new neural pathways. Scientists have discovered remarkable regenerative capabilities even in older individuals. This discovery has profound implications for treating neurological conditions.',
    expandedContent: '''The human brain, long thought to be "fixed" after early childhood, exhibits remarkable plasticity throughout life. New research challenges the long-held belief that adult brains cannot form new neural pathways or recover from damage.

Scientists from multiple institutions have discovered remarkable regenerative capabilities even in individuals over 60 years old. Using advanced imaging techniques, researchers tracked the formation of new neurons and synapses in response to learning and experience.

Key breakthroughs:
- Adult neurogenesis occurs in the hippocampus
- Environmental enrichment stimulates neural growth
- Learning new skills at any age creates structural changes
- Recovery from stroke is possible with proper rehabilitation

This discovery has profound implications for treating neurological conditions like Alzheimer's, Parkinson's, and traumatic brain injuries. It fundamentally changes how we approach aging and cognitive decline, suggesting that the brain retains the ability to rewire itself when properly stimulated.''',
    likeCount: 892,
    saveCount: 367,
  ),
  ContentItem(
    id: 3,
    category: 'Behavioral Science',
    headline: 'The Paradox of Choice',
    content:
        'Why having more options often leads to less satisfaction and increased anxiety. This psychological phenomenon affects everything from consumer behavior to career decisions. Understanding it can improve decision-making quality.',
    expandedContent: '''In an age of unprecedented abundance, we face a peculiar problem: having more options often leads to less satisfaction rather than more. This counterintuitive phenomenon, known as the Paradox of Choice, affects everything from consumer behavior to career decisions.

Pioneering research shows that while some choice is good, too much choice can be paralyzing. When faced with numerous options, people experience:
- Increased decision fatigue
- Higher anxiety and regret
- Analysis paralysis
- Reduced satisfaction with final choices

Real-world applications reveal striking patterns:
- Supermarkets with 40 jam varieties sell less than those with 4 varieties
- Career dissatisfaction peaks in markets with unlimited job options
- Dating app users report lower satisfaction than those with limited choices

Understanding this paradox enables us to design better systems—both for ourselves and organizations. By strategically limiting options and creating decision frameworks, we can improve outcomes and increase happiness.''',
    likeCount: 1567,
    saveCount: 823,
  ),
  ContentItem(
    id: 4,
    category: 'Cognitive Science',
    headline: 'Memory Encoding and Recall',
    content:
        'How the brain stores and retrieves information, and why some memories stick while others fade. Techniques for improving memory retention and encoding new information effectively. Practical strategies for students and professionals.',
    expandedContent: '''Memory is not a recording device but a reconstructive process. Understanding how the brain encodes, stores, and retrieves information reveals why some memories stick vividly while others fade almost immediately.

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

By understanding these mechanisms, students and professionals can implement evidence-based strategies to remember more effectively.''',
    likeCount: 654,
    saveCount: 298,
  ),
  ContentItem(
    id: 5,
    category: 'Philosophy',
    headline: 'The Nature of Consciousness',
    content:
        'Exploring the hard problem of consciousness and modern philosophical approaches. Scientists and philosophers debate whether consciousness can ever be fully understood. New perspectives challenge traditional views on the mind-body problem.',
    expandedContent: '''For centuries, philosophers and scientists have grappled with one of the deepest questions: what is consciousness? This inquiry, often called "the hard problem," remains one of the most perplexing challenges in philosophy and neuroscience.

The hard problem of consciousness asks: why do we have subjective experiences at all? Why doesn't information processing happen "in the dark," without any subjective feeling?

Current perspectives include:

Physicalism:
- Consciousness arises from physical brain processes
- All mental phenomena are ultimately physical
- Brain states correlate with conscious experiences

Dualism:
- Mind and body are fundamentally different substances
- Consciousness is non-physical
- Physical laws don't fully explain consciousness

Panpsychism:
- Consciousness is a fundamental feature of reality
- All matter has some form of consciousness
- Macroscopic consciousness emerges from basic particles

New research directions:
- Integrated Information Theory suggests consciousness relates to integrated information
- Global Workspace Theory proposes consciousness emerges from information availability
- Quantum theories explore potential quantum mechanisms in consciousness

These debates continue to shape our understanding of human experience and reality itself.''',
    likeCount: 2034,
    saveCount: 751,
  ),
  ContentItem(
    id: 6,
    category: 'Technology',
    headline: 'The Future of AI Ethics',
    content:
        'Examining the ethical implications of artificial intelligence development. As AI becomes more powerful, the need for ethical frameworks grows. Organizations worldwide are developing guidelines for responsible AI deployment.',
    expandedContent: '''Artificial Intelligence stands at a critical juncture. As AI systems become increasingly capable and integrated into society, the imperative for robust ethical frameworks has never been greater.

Key ethical challenges in AI development:

Bias and Fairness:
- AI systems inherit biases from training data
- Discriminatory outcomes harm marginalized groups
- Fairness metrics are difficult to define and measure
- Transparency in algorithmic decision-making is crucial

Privacy and Data Protection:
- AI requires massive amounts of data
- Personal information exposure risks increase
- Regulations like GDPR attempt to protect users
- Data ownership questions remain unresolved

Accountability and Transparency:
- "Black box" AI systems resist explanation
- Responsibility for AI errors is unclear
- Explainability research improves understanding
- Stakeholder communication is essential

Societal Impact:
- Job displacement through automation
- Power concentration in tech companies
- Digital divide widens access gaps
- Long-term societal transformation unknown

Organizations worldwide are developing ethical guidelines and principles for responsible AI. The challenge lies not just in creating these frameworks, but in ensuring implementation and accountability.''',
    likeCount: 1456,
    saveCount: 634,
  ),
  ContentItem(
    id: 7,
    category: 'Ecology',
    headline: 'Biodiversity Crisis and Conservation',
    content:
        'Understanding the rapid decline of species worldwide and conservation efforts. Earth is experiencing its sixth mass extinction event. Innovative approaches offer hope for protecting endangered ecosystems.',
    expandedContent: '''Earth's biodiversity is declining at an alarming rate. Scientists have identified this period as the sixth mass extinction—the first caused entirely by one species: humans.

The scale of the crisis:

Species Loss:
- One million species threatened with extinction
- Extinction rates 100-1000 times faster than natural baseline
- Forest loss accelerates species decline
- Ocean acidification threatens marine ecosystems

Primary causes:
- Habitat destruction and land use change
- Overexploitation of resources
- Climate change and pollution
- Invasive species disruption

Conservation strategies showing promise:

Protected Areas:
- Marine and terrestrial reserves preserve habitat
- Connectivity corridors enable species migration
- Community-based conservation respects indigenous knowledge
- International agreements strengthen protection

Restoration Efforts:
- Rewilding projects restore ecosystems
- Species reintroduction programs show success
- Habitat rehabilitation improves resilience
- Technology aids monitoring and protection

Innovation in conservation:
- Environmental DNA tracking rare species
- Artificial intelligence predicts extinction risk
- Blockchain enables transparent conservation funding
- Citizen science mobilizes public participation

Success stories demonstrate that extinction is not inevitable. With sustained effort and innovation, we can slow biodiversity loss.''',
    likeCount: 1789,
    saveCount: 892,
  ),
  ContentItem(
    id: 8,
    category: 'Economics',
    headline: 'Universal Basic Income: The Global Experiment',
    content:
        'Exploring pilot programs testing universal basic income across different countries. Results challenge traditional economic assumptions about work and motivation. Could UBI be the solution to economic inequality?',
    expandedContent: '''Universal Basic Income (UBI) has transitioned from theoretical concept to practical experiment. Countries and cities worldwide are testing whether providing unconditional cash to all citizens improves wellbeing and economic outcomes.

What is Universal Basic Income?

A regular cash payment to all citizens, unconditional on employment or other factors. The amount aims to cover basic needs, providing economic security regardless of job status.

Pilot programs worldwide:

Finland (2017-2018):
- 2,000 unemployed received €560/month
- Improved wellbeing and reduced stress
- No significant decrease in employment
- Increased sense of security and autonomy

Kenya (Ongoing):
- GiveDirectly distributed monthly payments
- Stimulated local economy and business creation
- Recipients invested in education and health
- Long-term social impacts being studied

Stockton, California (Ongoing):
- 125 residents received \$500/month
- Increased financial stability
- More time for caregiving and education
- Reduced financial anxiety and stress

Key findings from experiments:

Economic Effects:
- No significant decrease in work hours overall
- Recipients invest in education and skills
- Local economies receive stimulus from spending
- Entrepreneurship often increases

Wellbeing Improvements:
- Reduced stress and anxiety
- Better mental and physical health
- Increased social connection
- Greater life satisfaction

Challenges and questions:
- Funding mechanisms at scale remain unclear
- Inflation concerns when implemented broadly
- Whether effects persist long-term
- Global coordination complexities

These experiments provide crucial data for policy decisions about economic futures.''',
    likeCount: 945,
    saveCount: 421,
  ),
];

/// Content state
class ContentState {
  final List<ContentItem> content;
  final ContentItem? selectedContent;
  final bool isModalOpen;
  final bool isFullscreenOpen;
  final int fullscreenIndex;
  final int streak;
  final bool showTopBar;

  const ContentState({
    required this.content,
    this.selectedContent,
    this.isModalOpen = false,
    this.isFullscreenOpen = false,
    this.fullscreenIndex = 0,
    this.streak = 7,
    this.showTopBar = true,
  });

  ContentState copyWith({
    List<ContentItem>? content,
    ContentItem? selectedContent,
    bool? isModalOpen,
    bool? isFullscreenOpen,
    int? fullscreenIndex,
    int? streak,
    bool? showTopBar,
  }) {
    return ContentState(
      content: content ?? this.content,
      selectedContent: selectedContent ?? this.selectedContent,
      isModalOpen: isModalOpen ?? this.isModalOpen,
      isFullscreenOpen: isFullscreenOpen ?? this.isFullscreenOpen,
      fullscreenIndex: fullscreenIndex ?? this.fullscreenIndex,
      streak: streak ?? this.streak,
      showTopBar: showTopBar ?? this.showTopBar,
    );
  }
}

/// Content provider
final contentProvider =
    StateNotifierProvider<ContentNotifier, ContentState>((ref) {
  return ContentNotifier();
});

class ContentNotifier extends StateNotifier<ContentState> {
  ContentNotifier()
      : super(ContentState(
          content: List.from(sampleContent),
        ));

  void toggleLike(int id) {
    final updatedContent = state.content.map((item) {
      if (item.id == id) {
        final newLiked = !item.liked;
        return item.copyWith(
          liked: newLiked,
          likeCount: newLiked ? item.likeCount + 1 : item.likeCount - 1,
        );
      }
      return item;
    }).toList();

    // Increment streak if liking
    final wasLiked = state.content.firstWhere((item) => item.id == id).liked;
    final newStreak = !wasLiked ? state.streak + 1 : state.streak;

    state = state.copyWith(
      content: updatedContent,
      streak: newStreak,
    );
  }

  void toggleSave(int id) {
    final updatedContent = state.content.map((item) {
      if (item.id == id) {
        final newSaved = !item.saved;
        return item.copyWith(
          saved: newSaved,
          saveCount: newSaved ? item.saveCount + 1 : item.saveCount - 1,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(content: updatedContent);
  }

  void markShared(int id) {
    final updatedContent = state.content.map((item) {
      if (item.id == id) {
        return item.copyWith(shared: true);
      }
      return item;
    }).toList();

    state = state.copyWith(content: updatedContent);
  }

  void openModal(ContentItem content) {
    state = state.copyWith(
      selectedContent: content,
      isModalOpen: true,
    );
  }

  void closeModal() {
    state = state.copyWith(
      isModalOpen: false,
    );
  }

  void openFullscreen(int index) {
    state = state.copyWith(
      isFullscreenOpen: true,
      fullscreenIndex: index,
    );
  }

  void closeFullscreen() {
    state = state.copyWith(
      isFullscreenOpen: false,
    );
  }

  void setFullscreenIndex(int index) {
    state = state.copyWith(fullscreenIndex: index);
  }

  void setShowTopBar(bool show) {
    state = state.copyWith(showTopBar: show);
  }

  ContentItem? getContentById(int id) {
    return ContentService.findById(state.content, id);
  }

  int getContentIndex(int id) {
    return ContentService.findIndexById(state.content, id);
  }
}
