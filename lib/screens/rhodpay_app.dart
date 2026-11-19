import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

const forest = Color(0xFF092D25);
const green = Color(0xFF176B48);
const mint = Color(0xFF61D99B);
const page = Color(0xFFF1F6F3);

class RhodPayApp extends StatelessWidget {
  const RhodPayApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'RHODPAY Demo',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: page,
      colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light),
      appBarTheme: const AppBarTheme(backgroundColor: forest, foregroundColor: Colors.white),
    ),
    home: const AuthGate(),
  );
}


class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? displayName;
  String? email;
  @override
  Widget build(BuildContext context) {
    if (displayName != null) {
      return MainShell(userName: displayName!, userEmail: email ?? 'demo@rhodpay.test', onSignOut: () => setState(() { displayName = null; email = null; }));
    }
    return DemoAuthScreen(onContinue: (name, mail) => setState(() { displayName = name; email = mail; }));
  }
}

class DemoAuthScreen extends StatefulWidget {
  final void Function(String, String) onContinue;
  const DemoAuthScreen({super.key, required this.onContinue});
  @override
  State<DemoAuthScreen> createState() => _DemoAuthScreenState();
}

class _DemoAuthScreenState extends State<DemoAuthScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  bool register = false;
  bool accepted = false;
  @override
  void dispose() { name.dispose(); email.dispose(); super.dispose(); }
  void continueDemo() {
    final mail = email.text.trim();
    final person = register ? name.text.trim() : (mail.contains('@') ? mail.split('@').first : 'Demo User');
    if (mail.isEmpty || !mail.contains('@') || (register && person.isEmpty) || !accepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid demo email and accept the demo notice.')));
      return;
    }
    widget.onContinue(person, mail);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 28), const Center(child: RhodPayMark(size: 76)), const SizedBox(height: 14),
      const Center(child: Text('RHODPAY', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: forest))),
      const Center(child: Text('Your global wallet experience', style: TextStyle(color: Colors.black54))),
      const SizedBox(height: 28),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(register ? 'Create demo profile' : 'Welcome back', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: forest)),
        const SizedBox(height: 6), Text(register ? 'Set up a local prototype profile.' : 'Sign in to explore the RHODPAY demo.', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        if (register) TextField(controller: name, decoration: const InputDecoration(labelText: 'Display name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline))),
        if (register) const SizedBox(height: 12),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Demo email', hintText: 'demo@example.test', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined))),
        const SizedBox(height: 12),
        CheckboxListTile(value: accepted, onChanged: (v) => setState(() => accepted = v ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('I understand this is a simulated demo. No real account or money is involved.', style: TextStyle(fontSize: 12))),
        const SizedBox(height: 10),
        FilledButton(onPressed: continueDemo, style: FilledButton.styleFrom(backgroundColor: green, padding: const EdgeInsets.all(15)), child: Text(register ? 'Create demo profile' : 'Continue to demo')),
        TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'Already have a demo profile? Sign in' : 'New here? Create a demo profile')),
      ])),
      const SizedBox(height: 18), const Center(child: Text('DEMO ONLY • DO NOT ENTER REAL BANKING PASSWORDS', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold))),
    ])))));
}

class MainShell extends StatefulWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onSignOut;
  const MainShell({super.key, required this.userName, required this.userEmail, required this.onSignOut});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const WalletsScreen(),
      const PlaceholderScreen(title: 'Transactions', subtitle: 'Your simulated transaction history will appear here.'),
      const PlaceholderScreen(title: 'Profile', subtitle: 'Profile, preferences and demo security settings.'),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallets'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      Row(children: [
        const RhodPayMark(),
        const SizedBox(width: 10),
        const Text('RHOD', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: forest)),
        const Text('PAY', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: green)),
        const Spacer(),
        IconButton(onPressed: () => _demoNotice(context), icon: const Icon(Icons.notifications_none)),
      ]),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('TOTAL DEMO BALANCE', style: TextStyle(color: Color(0xFFB8D4C9), letterSpacing: 1.2, fontSize: 11)),
          SizedBox(height: 8),
          Text('\$12,450.80', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('SIMULATED FUNDS • NOT REAL MONEY', style: TextStyle(color: mint, fontSize: 10, fontWeight: FontWeight.bold)),
          SizedBox(height: 18),
          Row(children: [
            _CurrencyTile(code: 'USD', amount: '\$8,500.00'),
            SizedBox(width: 8),
            _CurrencyTile(code: 'GBP', amount: '£1,800.00'),
            SizedBox(width: 8),
            _CurrencyTile(code: 'EUR', amount: '€2,150.80'),
          ]),
        ]),
      ),
      const SizedBox(height: 22),
      const Text('Quick actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: forest)),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: .82,
        children: const [
          _ActionTile(icon: Icons.north_east, label: 'Send'),
          _ActionTile(icon: Icons.south_west, label: 'Receive'),
          _ActionTile(icon: Icons.currency_exchange, label: 'Exchange'),
          _ActionTile(icon: Icons.credit_card, label: 'Cards'),
          _ActionTile(icon: Icons.receipt_long, label: 'Invoices'),
          _ActionTile(icon: Icons.public, label: 'Countries'),
          _ActionTile(icon: Icons.receipt, label: 'Bills'),
          _ActionTile(icon: Icons.more_horiz, label: 'More'),
        ],
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Recent activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          SizedBox(height: 14),
          _ActivityRow(title: 'Demo payment received', amount: '+\$450.00', positive: true),
          Divider(height: 22),
          _ActivityRow(title: 'Demo transfer', amount: '-\$120.00', positive: false),
          Divider(height: 22),
          _ActivityRow(title: 'Demo currency exchange', amount: '€200.00', positive: true),
        ]),
      ),
      const SizedBox(height: 14),
      const Center(child: Text('RHODPAY is a simulation. No real funds or payments.', style: TextStyle(fontSize: 10, color: Colors.black54))),
    ],
  );
}

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});
  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  List<dynamic> all = [];
  String query = '';
  bool loaded = false;

  Future<void> load() async {
    if (loaded) return;
    final raw = await rootBundle.loadString('assets/data/country_wallets.json');
    final parsed = jsonDecode(raw) as List<dynamic>;
    if (mounted) setState(() { all = parsed; loaded = true; });
  }

  @override
  void didChangeDependencies() { super.didChangeDependencies(); load(); }

  @override
  Widget build(BuildContext context) {
    final filtered = all.where((e) => (e['name'] as String).toLowerCase().contains(query.toLowerCase())).toList();
    return Column(children: [
      Container(
        color: forest, padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Country wallets', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Browse countries alphabetically • Demo only', style: TextStyle(color: Color(0xFFB8D4C9))),
          const SizedBox(height: 14),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              hintText: 'Search countries',
              prefixIcon: const Icon(Icons.search),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        ]),
      ),
      Expanded(child: !loaded
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, i) {
              final item = filtered[i] as Map<String, dynamic>;
              final codes = (item['currencies'] as List<dynamic>).join(', ');
              return ListTile(
                leading: CircleAvatar(backgroundColor: const Color(0xFFDDEDE4), child: Text(item['code'], style: const TextStyle(color: forest, fontSize: 11, fontWeight: FontWeight.bold))),
                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(codes.isEmpty ? 'Currency mapping to be verified' : 'Currency: $codes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text(item['name']),
                  content: Text('This is a demo country-wallet preview. Currency: ${codes.isEmpty ? "To be verified" : codes}. No real account is created.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                )),
              );
            },
          )),
    ]);
  }
}


class ProfileScreen extends StatelessWidget {
  final String name, email;
  final VoidCallback onSignOut;
  const ProfileScreen({super.key, required this.name, required this.email, required this.onSignOut});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    const SizedBox(height: 24), const Center(child: RhodPayMark(size: 68)), const SizedBox(height: 14),
    const Center(child: Text('Demo profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: forest))),
    const SizedBox(height: 20), Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(name), subtitle: Text(email))),
    const SizedBox(height: 12), const ListTile(leading: Icon(Icons.verified_user_outlined), title: Text('Prototype account'), subtitle: Text('No identity verification or financial account is connected.')),
    const SizedBox(height: 18), OutlinedButton.icon(onPressed: onSignOut, icon: const Icon(Icons.logout), label: const Text('Exit demo profile')),
    const SizedBox(height: 18), const Center(child: Text('RHODPAY DEMO • Profile data is held in memory only.', style: TextStyle(fontSize: 10, color: Colors.black54))),
  ]);
}

class PlaceholderScreen extends StatelessWidget {
  final String title, subtitle;
  const PlaceholderScreen({super.key, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const RhodPayMark(size: 62),
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: forest)),
      const SizedBox(height: 8),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 12),
      const Chip(label: Text('Prototype module planned')),
    ]),
  ));
}

class RhodPayMark extends StatelessWidget {
  final double size;
  const RhodPayMark({super.key, this.size = 34});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(size * .28)),
    child: Center(child: Text('R', style: TextStyle(color: Colors.white, fontSize: size * .68, fontWeight: FontWeight.w900))),
  );
}

class _CurrencyTile extends StatelessWidget {
  final String code, amount;
  const _CurrencyTile({required this.code, required this.amount});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 7),
    decoration: BoxDecoration(color: Color(0xFF17463A), borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(code, style: const TextStyle(color: Color(0xFFB8D4C9), fontSize: 11)),
      const SizedBox(height: 4),
      FittedBox(child: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
    ]),
  ));
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionTile({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: green, size: 25),
      const SizedBox(height: 7),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ActivityRow extends StatelessWidget {
  final String title, amount;
  final bool positive;
  const _ActivityRow({required this.title, required this.amount, required this.positive});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(positive ? Icons.south_west : Icons.north_east, color: positive ? green : Colors.black54, size: 19),
    const SizedBox(width: 10),
    Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
    Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: positive ? green : forest)),
  ]);
}

void _demoNotice(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Demo notification centre — no live alerts.')),
);
