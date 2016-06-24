//
//  CalculatorBrain.swift
//  CRProjSwift
//
//  Created by 曾超然 on 16/6/22.
//  Copyright © 2016年 Chriz. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
//private variable
    
    private var accumulator: Double = 0.0
    private var internalProgram = [AnyObject]()
    private var pending: PendingBinaryOperationInfo?
    
//private method
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOpseration((Double, Double) -> Double)
        case Equal
    }
    
    private var operations = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "cos" : Operation.UnaryOperation(cos),
        "√" : Operation.UnaryOperation(sqrt),
        "×" : Operation.BinaryOpseration({$0 * $1}),
        "+" : Operation.BinaryOpseration({$0 + $1}),
        "-" : Operation.BinaryOpseration({$0 - $1}),
        "÷" : Operation.BinaryOpseration({$0 / $1}),
        "=" : Operation.Equal,
        "." : Operation.BinaryOpseration({
            let str1: String = String(Int($0)) + "."
            return Double(str1 + String(Int($1)))!
        })
    ]
    
    private func clearProgramList() {
        internalProgram.removeAll()
        accumulator = 0.0
        pending = nil
    }
    
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    
    private func executePendingBinaryOperaion()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
//interface
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(accumulator)
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOpseration(let function):
                executePendingBinaryOperaion()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equal:
                executePendingBinaryOperaion()
            }
        }
    }
    
    func cleanCalculator() {
        clearProgramList()
    }
    
    
    typealias PropertyList = AnyObject

    //对外隐藏细节,用户只知道有AnyObject这个属性
    var program : PropertyList {
        get {
            return internalProgram
        }
        set {
            clearProgramList()
            if let arrayOps = newValue as? [AnyObject]{
                for op in arrayOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    var description : String {
        get {
            var desc = ""
            for op in internalProgram {
                if let operand = op as? Double {
                    desc = desc.stringByAppendingString(String(operand))
                }else if let operation = op as? String {
                    if operation != "=" {
                        desc = desc.stringByAppendingString(operation)
                    }
                }
            }
            return desc
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}