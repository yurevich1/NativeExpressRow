//
//  NativeExpressRow.swift
//  NativeExpressRow
//
//  Created by Admin on 02.06.17.
//  Copyright © 2017 PS. All rights reserved.
//

//
//  NativeExpressRow.swift
//
//
//  Created by Petrukhin Vyacheslav on 05.11.16.
//  Copyright © 2016 Petrukhin Vyacheslav. All rights reserved.
//

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Eureka
import Firebase

open class NativeExpressCellOf<T: Equatable>: Cell<T>, CellType {
    fileprivate var nativeExpressAdView: GADNativeExpressAdView!
    fileprivate var ADMOB_NATIVE_UNITID = ""
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    open override func setup() {
        ADMOB_NATIVE_UNITID = row.value as! String
        height = {[unowned self] in CGFloat((self.row as! NativeExpressRowOf<T>).adHeight)}
        row.title = nil
        super.setup()
        selectionStyle = .none
        initAdsNativeExpress()
    }
    
    fileprivate func initAdsNativeExpress() {
        nativeExpressAdView = GADNativeExpressAdView()
        nativeExpressAdView.translatesAutoresizingMaskIntoConstraints = false
        nativeExpressAdView.contentMode = .redraw
        self.addSubview(nativeExpressAdView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[uiview]-0-|", options: [], metrics: nil, views: ["uiview": nativeExpressAdView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[uiview]-0-|", options: [], metrics: nil, views: ["uiview": nativeExpressAdView]))
        
        nativeExpressAdView.adUnitID = ADMOB_NATIVE_UNITID
        if let w = UIApplication.shared.delegate?.window, let vc = w?.rootViewController {
            nativeExpressAdView.rootViewController = vc
        }
        
        nativeExpressAdView.layoutIfNeeded()
        self.bringSubview(toFront: nativeExpressAdView)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        nativeExpressAdView.load(request)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func update() {
        row.title = nil
        super.update()
        accessoryType = .none
        editingAccessoryType = accessoryType
        
    }
    
}

public typealias NativeExpressCell = NativeExpressCellOf<String>


//MARK: NativeExpressRow

open class _NativeExpressRowOf<T: Equatable> : Row<NativeExpressCellOf<T>> {
    open var presentationMode: PresentationMode<UIViewController>?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.makeController(){
                    presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
                }
                else{
                    presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
    }
    
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        let rowVC = segue.destination as? RowControllerType
        rowVC?.onDismissCallback = presentationMode?.onDismissCallback
    }
}

public final class NativeExpressRowOf<T: Equatable> : _NativeExpressRowOf<T>, RowType {
    public var adHeight = 0.0
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public typealias NativeExpressRow = NativeExpressRowOf<String>
