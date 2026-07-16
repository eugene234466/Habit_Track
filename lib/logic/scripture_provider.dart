

const List<String> scriptures = [
  "I can do all this through him who gives me strength. — Philippians 4:13",
  "So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you. — Isaiah 41:10",
  "No temptation has overtaken you except what is common to mankind. And God is faithful; he will not let you be tempted beyond what you can bear. But when you are tempted, he will also provide a way out. — 1 Corinthians 10:13",
  "The Lord is my strength and my shield; my heart trusts in him, and he helps me. — Psalm 28:7",
  "Come to me, all you who are weary and burdened, and I will give you rest. — Matthew 11:28",
  "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future. — Jeremiah 29:11",
  "Cast all your anxiety on him because he cares for you. — 1 Peter 5:7",
  "The Lord is close to the brokenhearted and saves those who are crushed in spirit. — Psalm 34:18",
  "Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here! — 2 Corinthians 5:17",
  "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go. — Joshua 1:9",
  "He heals the brokenhearted and binds up their wounds. — Psalm 147:3",
  "Trust in the Lord with all your heart and lean not on your own understanding. — Proverbs 3:5",
  "Let us not become weary in doing good, for at the proper time we will reap a harvest if we do not give up. — Galatians 6:9",
  "Give all your worries and cares to God, for he cares about you. — 1 Peter 5:7",
  "The name of the Lord is a fortified tower; the righteous run to it and are safe. — Proverbs 18:10",
];

String getTodaysScripture() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  final index = dayOfYear % scriptures.length;
  return scriptures[index];
}