import UIKit

struct PDFGenerator {

    static func generate(petName: String, clientName: String, prescription: Prescription) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { context in
            context.beginPage()
            let textRect = CGRect(x: 40, y: 40, width: pageRect.width - 80, height: pageRect.height - 80)
            buildContent(petName: petName, clientName: clientName, prescription: prescription).draw(in: textRect)
        }
    }

    private static func buildContent(petName: String, clientName: String, prescription: Prescription) -> NSAttributedString {
        let title  = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let body   = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let bold14 = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]

        let prose = "\(petName) has been prescribed \(prescription.medicationName) \(prescription.dosage)\(prescription.dosageUnit), " +
                    "to be taken \(prescription.frequencyDescription.lowercased()) for \(prescription.durationDescription), " +
                    "starting on \(prescription.startDate.shortFormatted). " +
                    "The expected end date is \(prescription.endDate.shortFormatted)."

        let content = NSMutableAttributedString()
        content.append(NSAttributedString(string: "Prescription — \(prescription.title)\n\n", attributes: title))
        content.append(NSAttributedString(string: "Dear \(clientName),\n\n", attributes: body))
        content.append(NSAttributedString(string: prose + "\n\n", attributes: body))

        if !prescription.notes.isEmpty {
            content.append(NSAttributedString(string: "Notes & Instructions:\n", attributes: bold14))
            content.append(NSAttributedString(string: prescription.notes + "\n\n", attributes: body))
        }

        content.append(NSAttributedString(string: "Please contact our office if you have any questions or concerns.", attributes: body))
        return content
    }
}
