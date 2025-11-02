
import 'package:car_rental_project/main.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_project/database/database_helper.dart';

class FeedbackResultScreen extends StatefulWidget {
  const FeedbackResultScreen({super.key});

  @override
  State<FeedbackResultScreen> createState() => _FeedbackResultScreenState();
}

class _FeedbackResultScreenState extends State<FeedbackResultScreen> {
  List<Map<String, dynamic>> feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    final data = await DatabaseHelper.instance.getFeedbacksWithUser();
    setState(() {
      feedbackList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Feedbacks'),
        backgroundColor: const Color(0xFF4B6EF6),
        leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const MainNav()),
  (route) => false,
);
    },
  ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackList.isEmpty
              ? const Center(child: Text('Belum ada feedback 😔'))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackList[index];
                    final createdAt = feedback['created_at'] != null
                        ? DateTime.parse(feedback['created_at'])
                            .toLocal()
                            .toString()
                            .split('.')[0]
                        : '';
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading:
                            const Icon(Icons.feedback, color: Color(0xFF4B6EF6)),
                        title: Text(feedback['name'] ?? 'Anonymous'),
                        subtitle: Text(feedback['message'] ?? ''),
                        trailing: Text(
                          createdAt,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
