import 'package:cloud_firestore/cloud_firestore.dart';

class VaccineModel {
  final Timestamp created;
  final int dose;
  final List<dynamic> HealthWorkers;
  final String due_Age;
  final bool given;
  final String hospital_id;
  final String max_Age;
  final int remaining_vaccine;
  final String route;
  final String site;
  final String vaccine_Id;
  final String vaccine_name;

  VaccineModel(
      {this.created,
      this.dose,
      this.HealthWorkers,
      this.due_Age,
      this.given,
      this.hospital_id,
      this.max_Age,
      this.remaining_vaccine,
      this.route,
      this.site,
      this.vaccine_Id,
      this.vaccine_name});

  factory VaccineModel.fromMap(Map<String, dynamic> data) {
    return VaccineModel(
      created: data["created"],
      dose: data["dose"],
      due_Age: data["due_Age"],
      HealthWorkers: data["Health Workers"],
      hospital_id: data["hospital_id"],
      max_Age: data["max_Age"],
      remaining_vaccine: data["remaining_vaccine"],
      given: data["given"],
      route: data["route"],
      site: data["site"],
      vaccine_Id: data["vaccine_Id"],
      vaccine_name: data["vaccine_name"],
    );
  }
}
