part of 'workspace_sections.dart';

final class CompatibilityAndFeasibility extends WorkspaceSection {
  const CompatibilityAndFeasibility({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Compatibility & Feasibility';
  }
}

final class DeliveryAndAccountabilityStep extends RichTextStep {
  const DeliveryAndAccountabilityStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Delivery & Accountability';
  }

  @override
  String localizedDesc(BuildContext context) {
    return 'How do you proof trust and accountability for your project?';
  }
}

final class FeasibilityChecksStep extends RichTextStep {
  const FeasibilityChecksStep({
    required super.id,
    required super.data,
    super.charsLimit,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Feasibility checks';
  }

  @override
  String localizedDesc(BuildContext context) {
    return 'How will you check if your approach will work?';
  }
}
