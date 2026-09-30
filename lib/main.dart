import 'package:flutter/material.dart';

void main() {
  runApp(const AmlakYarApp());
}

class AppColors {
  static const primary = Color(0xFF287CF5);
  static const secondary = Color(0xFF6C63FF);
  static const bg = Color(0xFFF6F8FC);
  static const card = Colors.white;
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF7B8497);
  static const success = Color(0xFF20B486);
  static const warning = Color(0xFFF4A62A);
  static const danger = Color(0xFFE85858);
}

class AmlakYarApp extends StatelessWidget {
  const AmlakYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'املاک‌یار',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'sans',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8ECF3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;

  final pages = const [
    DashboardPage(),
    PropertiesPage(),
    ClientsPage(),
    DraftsPage(),
    AiMatchingPage(),
  ];

  void selectTab(int index) {
    setState(() {
      selected = index;
    });
  }

  final titles = const [
    'خانه',
    'املاک',
    'مشتریان',
    'پیش‌نویس‌ها',
    'تطبیق هوشمند',
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text(
          titles[selected],
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          const StatusPill(),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'تنظیمات',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          if (wide) const SizedBox(width: 250, child: SideNavigation()),
          Expanded(
            child: IndexedStack(index: selected, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (i) => setState(() => selected = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'خانه',
                ),
                NavigationDestination(
                  icon: Icon(Icons.apartment_outlined),
                  selectedIcon: Icon(Icons.apartment),
                  label: 'املاک',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'مشتریان',
                ),
                NavigationDestination(
                  icon: Icon(Icons.note_alt_outlined),
                  selectedIcon: Icon(Icons.note_alt),
                  label: 'پیش‌نویس',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: 'هوش مصنوعی',
                ),
              ],
            ),
    );
  }
}

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE9EDF4))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const LogoHeader(),
            const SizedBox(height: 20),
            _nav(context, Icons.home_outlined, 'خانه', 0),
            _nav(context, Icons.apartment_outlined, 'مدیریت املاک', 1),
            _nav(context, Icons.people_outline, 'مدیریت مشتریان', 2),
            _nav(context, Icons.note_alt_outlined, 'پیش‌نویس‌ها', 3),
            _nav(context, Icons.auto_awesome_outlined, 'تطبیق هوشمند', 4),
            const Divider(height: 32),
            _push(
              context,
              Icons.group_add_outlined,
              'افزودن همکار',
              const AddColleaguePage(),
            ),
            _push(
              context,
              Icons.groups_outlined,
              'مدیریت همکاران',
              const CollaboratorsPage(),
            ),
            _push(
              context,
              Icons.photo_library_outlined,
              'مدیریت رسانه',
              const MediaManagerPage(),
            ),
            const Spacer(),
            _push(
              context,
              Icons.person_outline,
              'پروفایل',
              const ProfilePage(),
            ),
            _push(
              context,
              Icons.settings_outlined,
              'تنظیمات',
              const SettingsPage(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _nav(BuildContext context, IconData icon, String title, int index) {
    final shell = context.findAncestorStateOfType<_AppShellState>();
    final active = shell?.selected == index;
    return ListTile(
      leading: Icon(icon, color: active ? AppColors.primary : AppColors.muted),
      title: Text(
        title,
        style: TextStyle(
          color: active ? AppColors.primary : AppColors.text,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: active,
      selectedTileColor: AppColors.primary.withValues(alpha: .08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => shell?.selectTab(index),
    );
  }

  Widget _push(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: AppColors.muted),
      title: Text(title),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const LogoHeader(),
            const SizedBox(height: 18),
            const UserMiniCard(),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('مشخصات کاربری'),
              onTap: () => _go(context, const ProfilePage()),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('امنیت'),
              onTap: () => _go(context, const SecurityPage()),
            ),
            ListTile(
              leading: const Icon(Icons.group_add_outlined),
              title: const Text('افزودن همکار'),
              onTap: () => _go(context, const AddColleaguePage()),
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('مدیریت همکاران'),
              onTap: () => _go(context, const CollaboratorsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('مدیریت رسانه'),
              onTap: () => _go(context, const MediaManagerPage()),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('تنظیمات ظاهری'),
              onTap: () => _go(context, const AppearancePage()),
            ),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('بک‌آپ و بازیابی'),
              onTap: () => _go(context, const BackupPage()),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('راهنما'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text('پشتیبانی'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('خروج'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.home_work_outlined,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'املاک‌یار',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const Text(
          'مدیریت هوشمند املاک و مشتریان',
          style: TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}

class UserMiniCard extends StatelessWidget {
  const UserMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFDCE8FF),
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نازنین محمدی',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'مدیر دفتر املاک',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: AppColors.success),
          SizedBox(width: 6),
          Text(
            'آنلاین',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PagePadding extends StatelessWidget {
  final Widget child;
  const PagePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: child,
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderGreeting(),
          const SizedBox(height: 18),
          const StatsGrid(),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  title: 'تسک‌های امروز',
                  subtitle: 'کارهای مهمی که امروز باید انجام شوند',
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const AddTaskDialog(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('تسک جدید'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((e) => TaskCard(task: e)),
        ],
      ),
    );
  }
}

class HeaderGreeting extends StatelessWidget {
  const HeaderGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFF4F0FF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سلام نازنین 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 5),
                Text(
                  'امروز ۲۸ شهریور ۱۴۰۵ است',
                  style: TextStyle(color: AppColors.muted),
                ),
                SizedBox(height: 12),
                Text(
                  'امروز ۵ کار مهم برای پیگیری داری.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 36, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('املاک فعال', '۱۲', Icons.apartment, AppColors.primary),
      ('مشتریان', '۸', Icons.people, AppColors.secondary),
      ('تسک امروز', '۵', Icons.check_circle_outline, AppColors.success),
      ('پیگیری فوری', '۳', Icons.priority_high, AppColors.warning),
    ];

    return LayoutBuilder(
      builder: (_, c) {
        final count = c.maxWidth > 700 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (_, i) {
            final item = items[i];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8ECF3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item.$4.withValues(alpha: .1),
                    child: Icon(item.$3, color: item.$4),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.$2,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        item.$1,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}

class Task {
  final String title;
  final String type;
  final String time;
  final IconData icon;
  final Color color;
  bool done;

  Task(
    this.title,
    this.type,
    this.time,
    this.icon,
    this.color, {
    this.done = false,
  });
}

final tasks = [
  Task(
    'تماس با مالک آپارتمان نیاوران',
    'پیگیری تماس',
    '۱۰:۰۰',
    Icons.phone,
    AppColors.primary,
  ),
  Task(
    'پیگیری قرارداد فروش',
    'اداری',
    '۱۱:۳۰',
    Icons.description_outlined,
    AppColors.secondary,
  ),
  Task(
    'هماهنگی بازدید با مشتری',
    'ملاقات',
    '۱۵:۰۰',
    Icons.people_alt_outlined,
    AppColors.success,
  ),
  Task(
    'پیگیری وضعیت ملک',
    'عمومی',
    '۱۷:۰۰',
    Icons.home_work_outlined,
    AppColors.warning,
  ),
];

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE8ECF3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Checkbox(
          value: widget.task.done,
          onChanged: (v) => setState(() => widget.task.done = v ?? false),
        ),
        title: Text(
          widget.task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: widget.task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${widget.task.type}  •  امروز'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.task.icon, color: widget.task.color),
            const SizedBox(width: 8),
            Text(
              widget.task.time,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String type = 'پیگیری تماس';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('افزودن تسک جدید'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'عنوان تسک',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: type,
              decoration: const InputDecoration(labelText: 'نوع کار'),
              items: const [
                'پیگیری تماس',
                'اداری',
                'ملاقات',
                'عمومی',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => type = v ?? type),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'تاریخ',
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'ساعت',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لغو'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ذخیره'),
        ),
      ],
    );
  }
}

final properties = [
  Property(
    'آپارتمان ۱۲۰ متری نیاوران',
    'فروش',
    '۱۲۰ متر',
    'تهران، نیاوران',
    AppColors.danger,
    Icons.apartment,
  ),
  Property(
    'ویلای ۳۵۰ متری لواسان',
    'فروش',
    '۳۵۰ متر',
    'لواسان',
    AppColors.warning,
    Icons.villa_outlined,
  ),
  Property(
    'زمین ۵۰۰ متری شهریار',
    'اجاره',
    '۵۰۰ متر',
    'شهریار',
    AppColors.success,
    Icons.landscape_outlined,
  ),
  Property(
    'آپارتمان ۹۰ متری ونک',
    'اجاره',
    '۹۰ متر',
    'تهران، ونک',
    AppColors.primary,
    Icons.apartment,
  ),
];

class Property {
  final String title;
  final String contract;
  final String area;
  final String address;
  final Color priority;
  final IconData icon;

  Property(
    this.title,
    this.contract,
    this.area,
    this.address,
    this.priority,
    this.icon,
  );
}

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  String filter = 'همه';

  @override
  Widget build(BuildContext context) {
    final list = filter == 'همه'
        ? properties
        : properties.where((p) => p.contract == filter).toList();

    return PagePadding(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  title: 'مدیریت املاک',
                  subtitle: 'لیست، فیلتر و ثبت املاک',
                ),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PropertyFormPage()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('ثبت ملک جدید'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SearchBox(hint: 'جستجو در املاک...'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['همه', 'فروش', 'اجاره']
                .map(
                  (e) => ChoiceChip(
                    label: Text(e),
                    selected: filter == e,
                    onSelected: (_) => setState(() => filter = e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          ...list.map((p) => PropertyCard(property: p)),
        ],
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final String hint;
  const SearchBox({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'جستجو...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.tune),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE8ECF3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                property.icon,
                size: 40,
                color: AppColors.primary.withValues(alpha: .7),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Chip(
                        label: Text(property.contract),
                        backgroundColor: property.priority.withValues(
                          alpha: .1,
                        ),
                        labelStyle: TextStyle(
                          color: property.priority,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${property.area}  •  ${property.address}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: property.priority),
                      const SizedBox(width: 5),
                      const Text(
                        'اولویت ثبت‌شده',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PropertyFormPage(property: property),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyFormPage extends StatefulWidget {
  final Property? property;
  const PropertyFormPage({super.key, this.property});

  @override
  State<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends State<PropertyFormPage> {
  String contract = 'فروش';
  String type = 'آپارتمان';
  String priority = 'معمولی';

  @override
  void initState() {
    super.initState();
    contract = widget.property?.contract ?? 'فروش';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property == null ? 'ثبت ملک' : 'ویرایش ملک'),
      ),
      body: PagePadding(
        child: FormSection(
          title: 'اطلاعات ضروری',
          child: Column(
            children: [
              SelectField(
                label: 'نوع قرارداد',
                value: contract,
                values: const ['خرید', 'فروش', 'اجاره'],
                onChanged: (v) => setState(() => contract = v),
              ),
              const SizedBox(height: 12),
              SelectField(
                label: 'نوع ملک',
                value: type,
                values: const ['آپارتمان', 'ویلا', 'زمین', 'دفتر', 'مغازه'],
                onChanged: (v) => setState(() => type = v),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'متراژ'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'شماره موبایل مالک',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'آدرس',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 12),
              SelectField(
                label: 'میزان اهمیت',
                value: priority,
                values: const ['معمولی', 'فوری', 'کم‌اهمیت', 'ارزشمند'],
                onChanged: (v) => setState(() => priority = v),
              ),
              const SizedBox(height: 24),
              FormSection(
                title: 'اطلاعات تکمیلی',
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'نام مالک',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'شماره دوم',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('افزودن مورد جدید'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FormSection(
                title: 'رسانه',
                child: Column(
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 42,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_file_outlined),
                      label: const Text('افزودن عکس و ویدیو'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('ذخیره و ثبت ملک'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const SelectField({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: values
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class FormSection extends StatelessWidget {
  final String title;
  final Widget child;
  const FormSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

final clients = [
  Client('سارا رضایی', 'خریدار', 'آپارتمان', 'فوری', Icons.person),
  Client('حمید کریمی', 'اجاره‌نشین', 'آپارتمان', 'معمولی', Icons.person),
  Client('ندا قاسمی', 'خریدار', 'ویلا', 'ارزشمند', Icons.person),
  Client('علی احمدی', 'اجاره‌نشین', 'دفتر', 'معمولی', Icons.person),
];

class Client {
  final String name, demand, propertyType, priority;
  final IconData icon;
  Client(this.name, this.demand, this.propertyType, this.priority, this.icon);
}

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String filter = 'همه';

  @override
  Widget build(BuildContext context) {
    final list = filter == 'همه'
        ? clients
        : clients.where((c) => c.demand == filter).toList();

    return PagePadding(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  title: 'مدیریت مشتریان',
                  subtitle: 'ثبت و پیگیری خریداران و اجاره‌نشین‌ها',
                ),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClientFormPage()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('ثبت مشتری جدید'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SearchBox(hint: 'جستجو در مشتریان...'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['همه', 'خریدار', 'اجاره‌نشین']
                .map(
                  (e) => ChoiceChip(
                    label: Text(e),
                    selected: filter == e,
                    onSelected: (_) => setState(() => filter = e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          ...list.map((c) => ClientCard(client: c)),
        ],
      ),
    );
  }
}

class ClientCard extends StatelessWidget {
  final Client client;
  const ClientCard({super.key, required this.client});

  Color get priorityColor {
    switch (client.priority) {
      case 'فوری':
        return AppColors.danger;
      case 'ارزشمند':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE8ECF3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: AppColors.primary.withValues(alpha: .1),
          child: Icon(client.icon, color: AppColors.primary),
        ),
        title: Text(
          client.name,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text('${client.demand}  •  ${client.propertyType}'),
        trailing: Chip(
          label: Text(client.priority),
          labelStyle: TextStyle(
            color: priorityColor,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: priorityColor.withValues(alpha: .1),
          side: BorderSide.none,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClientFormPage()),
        ),
      ),
    );
  }
}

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({super.key});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  String demand = 'خریدار';
  String propertyType = 'آپارتمان';
  String priority = 'معمولی';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت مشتری')),
      body: PagePadding(
        child: Column(
          children: [
            FormSection(
              title: 'اطلاعات ضروری',
              child: Column(
                children: [
                  SelectField(
                    label: 'نوع تقاضا',
                    value: demand,
                    values: const ['خرید', 'اجاره', 'خریدار', 'اجاره‌نشین'],
                    onChanged: (v) => setState(() => demand = v),
                  ),
                  const SizedBox(height: 12),
                  SelectField(
                    label: 'نوع ملک مورد نیاز',
                    value: propertyType,
                    values: const ['آپارتمان', 'ویلا', 'زمین', 'دفتر', 'مغازه'],
                    onChanged: (v) => setState(() => propertyType = v),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'نام مشتری',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'شماره موبایل',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectField(
                    label: 'اولویت',
                    value: priority,
                    values: const ['معمولی', 'فوری', 'کم‌اهمیت', 'ارزشمند'],
                    onChanged: (v) => setState(() => priority = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FormSection(
              title: 'اطلاعات تکمیلی',
              child: Column(
                children: [
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'یادداشت'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن مورد جدید'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ذخیره و ثبت مشتری'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraftsPage extends StatelessWidget {
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drafts = [
      'آپارتمان ۹۰ متری ونک - فروش',
      'مشتری جدید - اجاره آپارتمان',
      'زمین شهریار - اطلاعات اولیه',
    ];

    return PagePadding(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  title: 'پیش‌نویس‌ها',
                  subtitle: 'ثبت سریع اطلاعات قبل از ورود به فرم اصلی',
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const DraftDialog(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('پیش‌نویس جدید'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...drafts.map(
            (d) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAF2FF),
                  child: Icon(
                    Icons.note_alt_outlined,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  d,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('امروز • ذخیره نشده در رکورد اصلی'),
                trailing: PopupMenuButton<String>(
                  onSelected: (_) {},
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'property',
                      child: Text('تبدیل به ملک'),
                    ),
                    PopupMenuItem(
                      value: 'client',
                      child: Text('تبدیل به مشتری'),
                    ),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DraftDialog extends StatelessWidget {
  const DraftDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('پیش‌نویس سریع'),
      content: const TextField(
        maxLines: 7,
        decoration: InputDecoration(
          hintText: 'اطلاعات اولیه را اینجا بنویسید...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لغو'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ذخیره'),
        ),
      ],
    );
  }
}

class AiMatchingPage extends StatelessWidget {
  const AiMatchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PagePadding(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEDEBFF), Color(0xFFEAF5FF)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تطبیق هوشمند ملک و مشتری',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('پیشنهادهای هوش مصنوعی برای پیگیری سریع‌تر'),
                    ],
                  ),
                ),
                Chip(label: Text('پلن طلایی')),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...[
            ('آپارتمان نیاوران', 'علی محمدی', '۸۵٪'),
            ('ویلای لواسان', 'ندا قاسمی', '۷۸٪'),
            ('آپارتمان ونک', 'سارا رضایی', '۷۲٪'),
          ].map(
            (e) => MatchingCard(property: e.$1, client: e.$2, percent: e.$3),
          ),
        ],
      ),
    );
  }
}

class MatchingCard extends StatelessWidget {
  final String property, client, percent;
  const MatchingCard({
    super.key,
    required this.property,
    required this.client,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE8ECF3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatchingDetailPage(
              property: property,
              client: client,
              percent: percent,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 29,
                backgroundColor: Color(0xFFEAF2FF),
                child: Icon(Icons.apartment, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: .1),
                ),
                child: Center(
                  child: Text(
                    percent,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchingDetailPage extends StatelessWidget {
  final String property, client, percent;
  const MatchingDetailPage({
    super.key,
    required this.property,
    required this.client,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جزئیات تطبیق')),
      body: PagePadding(
        child: Column(
          children: [
            MatchingCard(property: property, client: client, percent: percent),
            const SizedBox(height: 10),
            FormSection(
              title: 'موارد مشترک',
              child: Column(
                children: const [
                  MatchRow('نوع ملک', 'آپارتمان', true),
                  MatchRow('محله', 'نیاوران', true),
                  MatchRow('متراژ', '۱۰۰ تا ۱۴۰ متر', true),
                  MatchRow('بودجه', 'متناسب', true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FormSection(
              title: 'موارد متفاوت',
              child: Column(
                children: const [
                  MatchRow('پارکینگ', 'نیاز به بررسی', false),
                  MatchRow('اولویت', 'نیاز به بررسی', false),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WorkflowPage()),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('شروع پیگیری'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('لغو تطبیق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchRow extends StatelessWidget {
  final String label, value;
  final bool match;
  const MatchRow(this.label, this.value, this.match, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        match ? Icons.check_circle : Icons.cancel,
        color: match ? AppColors.success : AppColors.danger,
      ),
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WorkflowPage extends StatefulWidget {
  const WorkflowPage({super.key});

  @override
  State<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends State<WorkflowPage> {
  int step = 0;
  final stages = ['تماس', 'علاقه', 'بازدید', 'مذاکره', 'معامله'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراحل پیگیری')),
      body: PagePadding(
        child: Column(
          children: [
            FormSection(
              title: 'خط زمان پیگیری',
              child: Column(
                children: [
                  for (int i = 0; i < stages.length; i++)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: i <= step
                            ? AppColors.primary
                            : AppColors.bg,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: i <= step ? Colors.white : AppColors.muted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        stages[i],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: i < step
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            )
                          : i == step
                          ? const Chip(label: Text('مرحله فعلی'))
                          : null,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: step < stages.length - 1
                        ? () => setState(() => step++)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('مرحله بعد'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                    label: const Text('تعیین یادآور'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FormSection(
              title: 'گزارش معامله',
              child: Column(
                children: const [
                  TextField(
                    decoration: InputDecoration(labelText: 'تاریخ نهایی'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'جزئیات معامله'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FormSection(
              title: 'تمدید اجاره',
              child: Column(
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.timer_outlined,
                      color: AppColors.warning,
                    ),
                    title: Text('۳۵ روز تا پایان قرارداد'),
                    subtitle: Text('برای تمدید به مشتری یادآوری کنید.'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone),
                    label: const Text('تماس برای تمدید'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddColleaguePage extends StatelessWidget {
  const AddColleaguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن همکار')),
      body: PagePadding(
        child: Column(
          children: [
            FormSection(
              title: 'جستجوی همکار',
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'شماره تلفن همکار',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      label: const Text('جستجو و ارسال درخواست'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FormSection(
              title: 'سطح دسترسی',
              child: Column(
                children: [
                  _access('مشاهده املاک'),
                  _access('ویرایش املاک'),
                  _access('مشاهده مشتریان'),
                  _access('ویرایش مشتریان'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _access(String title) {
    return CheckboxListTile(
      value: true,
      onChanged: (_) {},
      title: Text(title),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class CollaboratorsPage extends StatelessWidget {
  const CollaboratorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت همکاران')),
      body: PagePadding(
        child: Column(
          children: [
            ...['علی رضایی', 'مریم احمدی', 'سعید کریمی'].map(
              (name) => Card(
                elevation: 0,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(name),
                  subtitle: const Text('مشاهده و ویرایش املاک'),
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('تغییر دسترسی')),
                      PopupMenuItem(value: 'remove', child: Text('قطع همکاری')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: PagePadding(
        child: Column(
          children: [
            _SettingsItem(
              icon: Icons.person_outline,
              title: 'مشخصات کاربری',
              subtitle: 'نام، دفتر املاک و اطلاعات شغلی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.lock_outline,
              title: 'امنیت',
              subtitle: 'قفل برنامه و ورود با قفل گوشی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SecurityPage()),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.palette_outlined,
              title: 'تنظیمات ظاهری',
              subtitle: 'تم، رنگ و اندازه متن',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppearancePage()),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.backup_outlined,
              title: 'بک‌آپ و بازیابی',
              subtitle: 'ذخیره و بازیابی اطلاعات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BackupPage()),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.photo_library_outlined,
              title: 'مدیریت رسانه',
              subtitle: 'عکس‌ها و ویدیوهای املاک',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MediaManagerPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE8ECF3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String city = 'تهران';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشخصات کاربری')),
      body: PagePadding(
        child: FormSection(
          title: 'پروفایل',
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 42),
              ),
              const SizedBox(height: 18),
              const TextField(
                decoration: InputDecoration(labelText: 'نام و نام خانوادگی'),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'نام دفتر املاک'),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'عنوان شغلی'),
              ),
              const SizedBox(height: 12),
              SelectField(
                label: 'شهر',
                value: city,
                values: const ['تهران', 'کرج', 'مشهد', 'شیراز', 'تبریز'],
                onChanged: (v) => setState(() => city = v),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('ذخیره تغییرات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool pin = false;
  bool biometric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('امنیت')),
      body: PagePadding(
        child: FormSection(
          title: 'تنظیمات امنیتی',
          child: Column(
            children: [
              SwitchListTile(
                value: pin,
                onChanged: (v) => setState(() => pin = v),
                title: const Text('فعال‌سازی قفل ۴ رقمی'),
                subtitle: const Text('هنگام ورود به برنامه رمز درخواست شود'),
              ),
              if (pin)
                const TextField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'رمز ۴ رقمی'),
                ),
              SwitchListTile(
                value: biometric,
                onChanged: (v) => setState(() => biometric = v),
                title: const Text('استفاده از قفل گوشی'),
                subtitle: const Text('Biometric / PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  bool dark = false;
  double size = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات ظاهری')),
      body: PagePadding(
        child: FormSection(
          title: 'ظاهر برنامه',
          child: Column(
            children: [
              SwitchListTile(
                value: dark,
                onChanged: (v) => setState(() => dark = v),
                title: const Text('حالت تیره'),
              ),
              const ListTile(
                title: Text('رنگ اصلی برنامه'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 12,
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      radius: 12,
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.success,
                      radius: 12,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('اندازه متون'),
                subtitle: Slider(
                  value: size,
                  min: .8,
                  max: 1.3,
                  onChanged: (v) => setState(() => size = v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  double progress = .6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بک‌آپ و بازیابی')),
      body: PagePadding(
        child: Column(
          children: [
            FormSection(
              title: 'بک‌آپ آفلاین',
              child: Column(
                children: [
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'رمز عبور بک‌آپ',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 7),
                  Text('${(progress * 100).round()}٪ آماده‌سازی فایل'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => setState(() => progress = 1),
                      icon: const Icon(Icons.backup_outlined),
                      label: const Text('گرفتن بک‌آپ'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FormSection(
              title: 'بازیابی',
              child: Column(
                children: [
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'رمز بک‌آپ'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.restore),
                    label: const Text('انتخاب فایل و بازیابی'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaManagerPage extends StatelessWidget {
  const MediaManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = [
      ('ملک نیاوران', Icons.image_outlined),
      ('ویلای لواسان', Icons.videocam_outlined),
      ('آپارتمان ونک', Icons.image_outlined),
      ('زمین شهریار', Icons.image_outlined),
      ('ملک جدید', Icons.videocam_outlined),
      ('نمای داخلی', Icons.image_outlined),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت رسانه')),
      body: PagePadding(
        child: Column(
          children: [
            const SearchBox(hint: 'جستجو در رسانه‌ها...'),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: media.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 210,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, i) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8ECF3)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Icon(
                            media[i].$2,
                            size: 42,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        media[i].$1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool otp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: otp
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoHeader(),
                      const SizedBox(height: 30),
                      const Text(
                        'کد تایید را وارد کنید',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('کد ۵ رقمی ارسال‌شده به ۰۹۱۲***۶۷۸۹'),
                      const SizedBox(height: 24),
                      const TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '۱ ۲ ۳ ۴ ۵'),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () {},
                        child: const Text('ویرایش شماره'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AppShell()),
                        ),
                        child: const Text('تایید و ورود'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoHeader(),
                      const SizedBox(height: 35),
                      const TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'شماره موبایل',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => setState(() => otp = true),
                          child: const Text('ارسال کد تایید'),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
