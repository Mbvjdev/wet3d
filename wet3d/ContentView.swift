import SwiftUI
import RealityKit
import Combine
import AppKit

struct ContentView: View {
    @State private var processing = false
    @State private var outputURL: URL?
    @State private var errorMessage: String?
    @State private var selectedFolder: URL?

    var body: some View {
        VStack(spacing: 20) {
            if let folder = selectedFolder {
                Text("Valgt mappe: \(folder.lastPathComponent)")
            } else {
                Text("Ingen mappe valgt")
            }

            if let outputURL = outputURL {
                Text("Model generated!")
                Text(outputURL.lastPathComponent)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        NSWorkspace.shared.open(outputURL)
                    }
            } else if processing {
                Text("Processing images...")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }

            HStack {
                Button("Vælg Mappe") {
                    selectFolder()
                }

                Button("Generate 3D Model") {
                    guard let folder = selectedFolder else {
                        errorMessage = "Vælg venligst en mappe før du fortsætter."
                        return
                    }
                    startPhotogrammetry(with: folder)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(selectedFolder == nil)
            }

        }
        .padding()
    }

    func selectFolder() {
        let dialog = NSOpenPanel()
        dialog.title = "Vælg en mappe med billeder"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false

        if dialog.runModal() == .OK {
            if let result = dialog.url {
                selectedFolder = result
            }
        }
    }

    func startPhotogrammetry(with inputFolder: URL) {
        processing = true
        errorMessage = nil

        let outputFile = FileManager.default.temporaryDirectory.appendingPathComponent("output.usdz")
        let request = PhotogrammetrySession.Request.modelFile(url: outputFile)

        do {
            let session = try PhotogrammetrySession(input: inputFolder, configuration: .init())

            Task {
                do {
                    for try await output in session.outputs {
                        switch output {
                        case .processingComplete:
                            DispatchQueue.main.async {
                                self.outputURL = outputFile
                                self.processing = false
                            }
                        case .inputComplete:
                            print("Input processing complete.")
                        case .requestComplete(let request, let result):
                            print("Request \(request) completed with result: \(result)")
                        case .requestProgress(let request, let fractionComplete):
                            print("Request \(request) progress: \(fractionComplete * 100)%")
                        default:
                            break
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Photogrammetry failed: \(error.localizedDescription)"
                        self.processing = false
                    }
                }
            }

            try session.process(requests: [request])
        } catch {
            self.errorMessage = "Failed to start photogrammetry session: \(error.localizedDescription)"
            processing = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
