import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cliente.dart';

class ClientePDFGenerator {
  static Future<void> generatePDF(List<Cliente> clientes) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              'Relatório de Clientes',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Nome', 'Endereço', 'Contato', 'Observações'],
              data: clientes.map((cliente) {
                return [
                  cliente.id.toString(),
                  cliente.nome,
                  cliente.endereco,
                  cliente.contato,
                  cliente.observacoes,
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
