import 'package:assignment3/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_screen.dart';

class HomeScreen extends ConsumerWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    FirebaseAuth data = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey ${data.currentUser!.displayName}',style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black54
                ),),
                const Text('Start exploring resources'),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: SearchBar(
                        trailing: [
                          IconButton(onPressed: (){}, icon: const Icon(Icons.close)),
                        ],
                        leading: const Icon(Icons.search),
                      ),
                    ),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.filter_list_alt))
                  ],
                ),
              ],
            ),
            SizedBox(height: 12,),
            Text("Latest Uploads", style: TextStyle(
              fontSize: 16,
            ),),

            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('entries')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No entries found.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot entry = snapshot.data!.docs[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(entry['profilePicture'] ??
                              'https://example.com/default_profile_picture.png'),
                        ),
                        title: Text(entry['title']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry['description']),
                            Text('Uploaded by: ${entry['uploaderName']}'),
                            Text(
                                'Created at: ${entry['createdAt'] != null ? (entry['createdAt'] as Timestamp).toDate() : 'Unknown'}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateScreen(
                                entryId: entry.id,
                                title: entry['title'],
                                description: entry['description'],
                                uploaderName: entry['uploaderName'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
