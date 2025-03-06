class PocPodService {
  final bool isOnline;

  PocPodService({required this.isOnline});

  String getTitle() {
    return isOnline ? 'Online POD' : 'Offline POD';
  }

  String getContent() {
    return isOnline ? 'Online Content' : 'Offline Content';
  }
}
