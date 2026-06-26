import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/repositories/template_repository.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/contract.dart';

class TemplateService {
  final TemplateRepository _repo = TemplateRepository();

  Future<Contract> instantiate(String templateId, {Map<String, String>? variables}) async {
    final template = await _repo.load(templateId);
    final defaults = Contract(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _typeFromTemplate(templateId),
      property: const Property(),
      payment: const Payment(),
    );
    return defaults;
  }

  ContractType _typeFromTemplate(String templateId) {
    switch (templateId) {
      case 'default_contract': return ContractType.directSale;
      case 'usufruct_sale': return ContractType.usufructSale;
      case 'common_share_sale': return ContractType.commonShareSale;
      case 'inheritance_agreement': return ContractType.inheritanceAgreement;
      case 'partition': return ContractType.partition;
      case 'settlement': return ContractType.settlement;
      case 'promise': return ContractType.promise;
      case 'judicial_sale': return ContractType.judicialSale;
      case 'judicial_inheritance': return ContractType.judicialInheritance;
      case 'judicial_partition': return ContractType.judicialPartition;
      case 'judicial_exit': return ContractType.judicialExit;
      case 'complex_property': return ContractType.complexProperty;
      default: return ContractType.directSale;
    }
  }

  Future<List<String>> listTemplates() async {
    final ids = <String>[
      'default_contract',
      'usufruct_sale',
      'common_share_sale',
      'inheritance_agreement',
      'partition',
      'settlement',
      'promise',
      'judicial_sale',
      'judicial_inheritance',
      'judicial_partition',
      'judicial_exit',
      'complex_property',
    ];
    return ids;
  }
}