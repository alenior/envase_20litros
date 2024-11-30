import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/atendimento.dart';

class AtendimentoPDFGenerator {
  static Future<void> generatePDF(List<Atendimento> atendimentos) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Relatório de Atendimentos', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['ID', 'Cliente ID', 'Quantidade', 'Data', 'Observação'],
              data: atendimentos.map((atendimento) {
                return [
                  atendimento.id,
                  atendimento.clienteId,
                  atendimento.quantidade,
                  atendimento.data.toIso8601String(),
                  atendimento.observacao,
                ];
              }).toList(),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
