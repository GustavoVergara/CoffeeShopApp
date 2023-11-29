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
    let productCustomizationStream: ProductCustomizationStreaming

    func build() -> some View {
        let viewModel = AddToDraftOrderButtonViewModel(currentPrice: productCustomizationStream.data?.currentPrice,
                                                       selectedQuantity: productCustomizationStream.data?.selectedQuantity ?? 1,
                                                       canAddToDraftOrder: true)
        let interactor = AddToDraftOrderInteractor(productCustomizationWorker: productCustomizationWorker,
                                                   presenter: viewModel,
                                                   productCustomizationStream: productCustomizationStream)
        return AddToDraftOrderButton(interactor: interactor, viewModel: viewModel)
    }
}

// MARK: - Preview
struct AddToDraftOrderButtonBuilderPreview: AddToDraftOrderButtonBuilding {
    func build() -> some View {
        let data = ProductCustomizationData(
            sections: [
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
            selectedQuantity: 1,
            currentPrice: 10,
            hasSelectedAllRequiredCustomizations: false
        )
        let stream = ProductCustomizationStream()
        stream.emit(data)
        let customizationWorker = ProductCustomizationWorker(productCustomizationStream: stream, basePrice: data.currentPrice)

        let viewModel = AddToDraftOrderButtonViewModel(currentPrice: data.currentPrice,
                                                       selectedQuantity: data.selectedQuantity,
                                                       canAddToDraftOrder: data.hasSelectedAllRequiredCustomizations)
        let interactor = AddToDraftOrderInteractor(productCustomizationWorker: customizationWorker,
                                                   presenter: viewModel,
                                                   productCustomizationStream: stream)
        return AddToDraftOrderButton(interactor: interactor, viewModel: viewModel)
    }
}
