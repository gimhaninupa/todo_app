import 'package:flutter/material.dart';

// ==========================================
// 1. GLOBAL SETTINGS & DATA MODELS
// ==========================================

// A simple way to manage the Theme (Dark/Light) globally
final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

// Our Task Model - Describes what a "Task" looks like
class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  String category;
  String priority; // 'Low', 'Medium', 'High'
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });
}

// ==========================================
// 2. MAIN APP ENTRY POINT
// ==========================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We listen to the theme notifier to toggle dark mode instantly
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pro ToDo',
          themeMode: mode,
          // LIGHT THEME
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // DARK THEME
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// ==========================================
// 3. SPLASH SCREEN (Screen 1)
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds then go to Onboarding
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "TaskMaster",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. ONBOARDING SCREEN (Screen 2)
// ==========================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Icon(Icons.auto_awesome, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text(
                "Organize your\nLife with ease",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 20),
              _buildFeatureRow(Icons.check_circle, "Create and manage tasks simply"),
              _buildFeatureRow(Icons.alarm, "Set reminders so you never forget"),
              _buildFeatureRow(Icons.category, "Categorize work, personal, and more"),
              _buildFeatureRow(Icons.dark_mode, "Dark mode support included"),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Go to Home Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Get Started", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple[300]),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// ==========================================
// 5. HOME SCREEN (Main Hub)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- STATE VARIABLES ---
  String _username = "Gimhan";
  String _selectedCategory = "All";
  
  // Our list of tasks (In memory)
  final List<Task> _tasks = [];

  // Helper to get formatted date
  String get _todayDate {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "Today, ${months[now.month - 1]} ${now.day}";
  }

  // --- LOGIC ---
  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index].isCompleted = !_tasks[index].isCompleted;
      }
    });
  }

  void _clearCompleted() {
    setState(() {
      _tasks.removeWhere((t) => t.isCompleted);
    });
  }

  void _updateUsername(String newName) {
    setState(() {
      _username = newName;
    });
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    // Filter tasks based on selected category and completion status
    // We only show incomplete tasks on the main list (unless customized)
    List<Task> visibleTasks = _tasks.where((t) {
      if (t.isCompleted) return false; // Completed tasks go to "History"
      if (_selectedCategory == "All") return true;
      return t.category == _selectedCategory;
    }).toList();

    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, $_username 👋", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const Text("My To-Dos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Completed Tasks",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedTasksScreen(
                    tasks: _tasks,
                    onToggle: _toggleTask,
                    onDelete: _deleteTask,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    username: _username,
                    onUpdateUsername: _updateUsername,
                    onClearCompleted: _clearCompleted,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Date Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              _todayDate,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),

          // 2. Category Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildCategoryChip("All"),
                _buildCategoryChip("Work"),
                _buildCategoryChip("Personal"),
                _buildCategoryChip("Shopping"),
                _buildCategoryChip("Health"),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 3. Task List
          Expanded(
            child: visibleTasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = visibleTasks[index];
                      return TaskCard(
                        task: task,
                        onToggle: () => _toggleTask(task.id),
                        onTap: () {
                          // Navigate to Details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsScreen(
                                task: task,
                                onDelete: () {
                                  _deleteTask(task.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // FAB - ADD TASK
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = label;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.deepPurple[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.deepPurple : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        // FIXED: Use 'side' property with 'BorderSide', not 'border' with 'Border.all'
        side: isSelected 
            ? const BorderSide(color: Colors.transparent) 
            : BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            "No tasks in $_selectedCategory!",
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full screen height if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => AddTaskSheet(onSave: _addTask),
    );
  }
}

// ==========================================
// 6. TASK CARD WIDGET
// ==========================================
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onToggle, required this.onTap});

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.redAccent;
      case 'Medium': return Colors.orangeAccent;
      case 'Low': return Colors.green;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Checkbox
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (v) => onToggle(),
                  activeColor: Colors.deepPurple,
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 8),
              
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          "${task.dueDate.month}/${task.dueDate.day} • ${task.dueTime.format(context)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.category,
                            style: const TextStyle(fontSize: 10, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Priority Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 7. ADD TASK SHEET
// ==========================================
class AddTaskSheet extends StatefulWidget {
  final Function(Task) onSave;

  const AddTaskSheet({super.key, required this.onSave});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = "Personal";
  String _selectedPriority = "Medium";

  void _submit() {
    if (_titleController.text.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descController.text,
      dueDate: _selectedDate,
      dueTime: _selectedTime,
      category: _selectedCategory,
      priority: _selectedPriority,
    );

    widget.onSave(newTask);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    // Handle keyboard covering text fields
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("New Task", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 15),
          
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: "Description (Optional)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: "Date", border: OutlineInputBorder()),
                    child: Text("${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: _pickTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: "Time", border: OutlineInputBorder()),
                    child: Text(_selectedTime.format(context)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                  items: ["Work", "Personal", "Shopping", "Health", "Other"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(labelText: "Priority", border: OutlineInputBorder()),
                  items: ["Low", "Medium", "High"]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPriority = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Create Task", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. TASK DETAILS SCREEN
// ==========================================
class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskDetailsScreen({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(task.category), backgroundColor: Colors.deepPurple[50]),
                const SizedBox(width: 10),
                Chip(
                  label: Text(task.priority),
                  backgroundColor: task.priority == 'High' ? Colors.red[50] : Colors.blue[50],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(task.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Due: ${task.dueDate.month}/${task.dueDate.day} at ${task.dueTime.format(context)}",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              task.description.isEmpty ? "No description provided." : task.description,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Show confirmation
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Task?"),
                      content: const Text("This cannot be undone."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                        TextButton(onPressed: () {
                          Navigator.pop(ctx);
                          onDelete(); // Delete and go back handled by parent
                        }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Delete Task", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 9. COMPLETED TASKS SCREEN
// ==========================================
class CompletedTasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const CompletedTasksScreen({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Only show completed tasks
    final completed = tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Completed Tasks")),
      body: completed.isEmpty
          ? const Center(child: Text("No completed tasks yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: completed.length,
              itemBuilder: (context, index) {
                final task = completed[index];
                return Dismissible(
                  key: Key(task.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (dir) => onDelete(task.id),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                      trailing: IconButton(
                        icon: const Icon(Icons.restore),
                        onPressed: () {
                           onToggle(task.id); // Toggle back to incomplete
                           Navigator.pop(context); // Go back to home to see it
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 10. SETTINGS SCREEN
// ==========================================
class SettingsScreen extends StatelessWidget {
  final String username;
  final Function(String) onUpdateUsername;
  final VoidCallback onClearCompleted;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.onUpdateUsername,
    required this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: username);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          // Profile Section
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Username"),
            subtitle: Text(username),
            trailing: const Icon(Icons.edit),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Edit Name"),
                  content: TextField(controller: nameController),
                  actions: [
                    TextButton(
                      onPressed: () {
                        onUpdateUsername(nameController.text);
                        Navigator.pop(ctx);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          // Theme Toggle
          ValueListenableBuilder<ThemeMode>(
            valueListenable: _themeNotifier,
            builder: (_, mode, __) {
              return SwitchListTile(
                title: const Text("Dark Mode"),
                secondary: const Icon(Icons.dark_mode),
                value: mode == ThemeMode.dark,
                onChanged: (val) {
                  _themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
          
          SwitchListTile(
            title: const Text("Notifications"),
            subtitle: const Text("Reminders for due tasks"),
            secondary: const Icon(Icons.notifications),
            value: true, // Dummy value
            onChanged: (val) {}, // No logic yet
          ),

          const Divider(),

          // Danger Zone
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text("Clear Completed Tasks", style: TextStyle(color: Colors.red)),
            onTap: () {
               onClearCompleted();
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cleared!")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: const Text("Version 1.0.0"),
          ),
        ],
      ),
    );
  }
}