//
//  File.swift
//  
//
//  Created by Gustavo Vergara on 07/11/23.
//

import SwiftUI

protocol AddToDraftOrderButtonBuilding {
    associatedtype Content: View
    func build() -> Content
}

struct AddToDraftOrderButtonBuilder: AddToDraftOrderButtonBuilding {
    let productCustomizationWorker: ProductCustomizationWorking
    
    func build() -> some View {
        let viewModel = AddToDraftOrderButtonViewModel(currentDisplayPrice: productCustomizationWorker.currentDisplayPrice, selectedQuantity: productCustomizationWorker.selectedQuantity)
        let interactor = AddToDraftOrderInteractor(productCustomizationWorker: productCustomizationWorker,
                                                   presenter: viewModel)
        return AddToDraftOrderButton(interactor: interactor, viewModel: viewModel)
    }
}

// MARK: - Preview
struct AddToDraftOrderButtonBuilderPreview: AddToDraftOrderButtonBuilding {
    func build() -> some View {
        let customizationWorker = ProductCustomizationWorker(
            customizationSections: [
                ProductCustomizationSection(
                    id: "preview-tamanho",
                    title: "Tamanho",
                    options: [
                        ProductCustomization(
                            name: "Pequeno",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Médio",
                            additionalPrice: 2,
                            isSelected: false),
                        ProductCustomization(
                            name: "Grande",
                            additionalPrice: 4,
                            isSelected: false)
                    ]
                ),
                ProductCustomizationSection(
                    id: "preview-adocante",
                    title: "Adoçar?",
                    options: [
                        ProductCustomization(
                            name: "Sem Açucar",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar Mascavo",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar de Baunilha",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar Cristal",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Sucralose",
                            additionalPrice: 0,
                            isSelected: false)
                    ]
                )
            ],
            basePrice: 10
        )

        let viewModel = AddToDraftOrderButtonViewModel(currentDisplayPrice: customizationWorker.currentDisplayPrice, selectedQuantity: customizationWorker.selectedQuantity)
        let interactor = AddToDraftOrderInteractor(productCustomizationWorker: customizationWorker,
                                                   presenter: viewModel)
        return AddToDraftOrderButton(interactor: interactor, viewModel: viewModel)
    }
}
