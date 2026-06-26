import '../../application/services/export_service.dart';
import '../../domain/models/contract.dart';

class PdfExportUseCase {
  final ExportService _service = ExportService();

  Future<String> exportPdf(Contract contract, {bool blank = false}) async {
    final file = await _service.exportPdf(contract, blank: blank);
    return file.path;
  }

  Future<String> exportBlankTemplate(Contract contract) async {
    final file = await _service.exportPdf(contract, blank: true);
    return file.path;
  }

  Future<String?> exportImage(Contract contract) async {
    final file = await _service.exportJpg(contract);
    return file?.path;
  }

  Future<String> exportTxt(Contract contract) async {
    final file = await _service.exportTxt(contract);
    return file.path;
  }
}