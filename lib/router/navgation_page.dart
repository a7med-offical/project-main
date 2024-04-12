import 'package:bldapp/view/updatessss/scan_qr_code.dart';
import 'package:go_router/go_router.dart';

class RouterData {
  static const scanQr = '/scan';
  static const donarInfo = '/donarInfo';

  final router = GoRouter(
    routes: [
      GoRoute(
        path: scanQr,
        builder: (context, state) => ScanQRCodeForAdd(),
      ),
      //   GoRoute(
      //   path: donarInfo,
      //   builder: (context, state) => DonarDetailsInfo(),
      // ),
    ],
  );
}
