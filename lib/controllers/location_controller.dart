import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
   import '../common/permission_location.dart';

class LocationController extends GetxController {
   /// Declare the postion also the lat long just for example
   late Position? posinitial;
   final lat = 0.0.obs;
   final lng = 0.0.obs;
   @override
   void onInit() async {
      /// Run through here

      super.onInit();
   }

   updatePosition()async{
      print("init location controller ");
      await PermissionLocation.permissionForLocation().then((value) async {
         posinitial = await PermissionLocation.determinePosition();
      }).whenComplete(() {
         getPositionData();
      });
   }

   getPositionData() async{
      print("get position data");

      // try to log the data if its not empty
      if (posinitial != null) {
         print("posinitial !null ");
           /// just pass this to ui to use
         lat.value = posinitial!.latitude;
         lng.value = posinitial!.longitude;
         print("posinitial !null ${lat}, ${lng}");

      }
   }

}