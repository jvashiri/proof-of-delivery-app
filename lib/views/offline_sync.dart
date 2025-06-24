import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/sync_screen_controller.dart';
import '../models/pod_model.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncScreenController _controller = SyncScreenController();
  List<PodModel> _pendingData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final pods = await _controller.getPendingPods();
    setState(() => _pendingData = pods);
  }

  Future<void> _syncAll() async {
    if (!await _controller.isConnected()) {
      _showMessage("No internet connection");
      return;
    }

    for (final pod in _pendingData) {
      await _controller.syncPod(pod);
    }

    _showMessage("All data synced successfully.");
    _loadData();
  }

  Future<void> _syncOne(PodModel pod) async {
    if (!await _controller.isConnected()) {
      _showMessage("No internet connection");
      return;
    }

    await _controller.syncPod(pod);
    _showMessage("Synced ${pod.waybill}");
    _loadData();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _shareLink(String waybill) async {
    final url = "https://otp.webfarming.co.za/web/upload.html?waybill=$waybill";
    final message =
        "Please upload the POD image for waybill $waybill using this link:\n$url";

    try {
      await Share.share(
        message,
        subject: 'Upload POD Image',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error sharing link: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share the link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncAll,
            tooltip: "Sync All",
          ),
        ],
      ),
      body: _pendingData.isEmpty
          ? const Center(child: Text("No data to sync"))
          : ListView.builder(
              itemCount: _pendingData.length,
              itemBuilder: (context, index) {
                final pod = _pendingData[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("Waybill: ${pod.waybill}"),
                    subtitle: Text("${pod.customer} • ${pod.location}"),
                    trailing: Wrap(
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          tooltip: "Share Upload Link",
                          onPressed: () => _shareLink(pod.waybill),
                        ),
                        IconButton(
                          icon: const Icon(Icons.sync),
                          tooltip: "Sync Now",
                          onPressed: () => _syncOne(pod),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
