// ignore_for_file: non_constant_identifier_names
class ApiUri {
  static String appkey = "3b8d4deb84c0d9b65070c872e2f73626f23d8dc8789a7a05";

  static String bASEURL = "https://app.trackfleetio.com/api";

  static String login = "$bASEURL/session";
  static fetchAllDevices(id) {
    return "$bASEURL/devices/get?userId=$id&all=true";
  }

  static String getAllGeoFences = '$bASEURL/geofences';
  static String addGeoFence = '$bASEURL/geofences';
  static String getAllCommands = '$bASEURL/commands';
  static String getAllMaintenance = '$bASEURL/maintenance';
  static deleteMaintenance(id) {
    return '$bASEURL/maintenance/$id';
  }

  static String getAllDrivers = '$bASEURL/drivers';
  static String getAllPositions = '$bASEURL/positions';
  static getTimeLapHistory(id, startT, endT) {
    return '$bASEURL//reports/timelap?deviceId=$id&&type=allEvents&from=$startT&to=$endT';
  }
  // static String getTimeLapHistory = ;

}
