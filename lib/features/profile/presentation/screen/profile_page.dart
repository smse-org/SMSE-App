import 'package:flutter/material.dart';
import 'package:smse/constants.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Web/Desktop Layout
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Profile', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
            ),
            body: const ProfileContentWeb(),
          );
        } else {
          // Mobile Layout
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Profile', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
            ),
            body: ProfileContentMobile(),
          );
        }
      },
    );
  }
}

class ProfileContentMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Information
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage(Constant.profileImage),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jane Doe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "jane.doe@example.com",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User Preferences
            const Text(
              "User Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Set default search file types"),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text("Enable notifications"),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),

            // Saved Searches
            const Text(
              "Saved Searches",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text("Sunset Beach Photo"),
              leading: Icon(Icons.photo, color: Colors.grey[700]),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Document on AI"),
              leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Feedback & Support
            const Text(
              "Feedback & Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Center(
                child: Text("Send Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileContentWeb extends StatelessWidget {
  const ProfileContentWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Information
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(Constant.profileImage),
                  ),
                  const SizedBox(width: 16),
                  const Center(
                    child: Text(
                      "Jane Doe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "jane.doe@example.com",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // User Preferences
              const Text(
                "User Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text("Set default search file types"),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text("Enable notifications"),
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),

              // Saved Searches
              const Text(
                "Saved Searches",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text("Sunset Beach Photo"),
                leading: Icon(Icons.photo, color: Colors.grey[700]),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Document on AI"),
                leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Feedback & Support
              const Center(
                child: Text(
                  "Feedback & Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width:MediaQuery.sizeOf(context).width*0.5 ,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      minimumSize: Size(200, 50),
                    ),
                    child: const Center(
                      child: Text("Send Feedback"),
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