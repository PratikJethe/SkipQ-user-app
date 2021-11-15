import 'package:json_annotation/json_annotation.dart';

enum Gender { MALE, FEMALE, OTHER, NONE }

enum TokenStatus {
  @JsonValue('REQUESTED')
  REQUESTED,
  @JsonValue('CANCELLED_REQUESTED')
  CANCELLED_REQUESTED,
  @JsonValue('REJECTED_REQUEST')
  REJECTED_REQUEST,
  @JsonValue('PENDING_TOKEN')
  PENDING_TOKEN,
  @JsonValue('CANCELLED_TOKEN')
  CANCELLED_TOKEN,
  @JsonValue('REJECTED_TOKEN')
  REJECTED_TOKEN,
  @JsonValue('COMPLETED_TOKEN')
  COMPLETED_TOKEN
}
enum UserType {
  @JsonValue('ONLINE')
  ONLINE,

  @JsonValue('OFFLINE')
  OFFLINE
}


enum TokenActionButtonState{
  LOADING,
  ERROR,
  REQUEST,
  CANCEL_REQUEST,
  CANCEL_TOKEN,
  NAVIGATE
}