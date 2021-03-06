//
//  WLNaviAnimation.swift
//  WLTransitionKit_SwiftDemo
//
//  Created by three stone 王 on 2018/11/20.
//  Copyright © 2018年 three stone 王. All righWL reserved.
//

import UIKit
import WLToolsKit

// v 1.0.5 之前是有bug存在的 就是转场的时候 由于是屏幕截图 回导致一些效果 比如点击按钮的高亮状态 不是立即消失

// 所以在v 1.0.6之后 修复这个bug
// 1.含有tabbar的一级界面跳转到二级界面 或 二级跳转到三级。。。
// 2.针对containerview 和fromview 重新布局
// 3.现在已有的网上开源的转场 会有些体验上的不好的地方
// 4.参考已成熟应用 如今日头条

// 之后会加入其他的 push pop转场

// 视图层级 window -> tabbar.view -> navi.view -> vc.view 转场时是有个container

public class WLNaviAnimation: WLBaseAnimation {
    
    open override func push(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let from = transitionContext.viewController(forKey: .from)!
        
        let to = transitionContext.viewController(forKey: .to)!
        
        guard let navi = to.navigationController else {
            
            fatalError("WLNaviAnimation 请确认有导航!")
        }
        
        let container = transitionContext.containerView
        
        container.addSubview(to.view)
        
        let fromConfig: WLNaviAnimationConfig = from.__animation_config!
        
        let duration = transitionDuration(using: transitionContext)
        
        let fromBaseView = UIView(frame: WL_SCREEN_BOUNDS)
        
        let topView = configTopView(config: fromConfig)
        
        let tabbarImageView = UIImageView(image: fromConfig.tabbarImage)
        
        tabbarImageView.frame = fromConfig.tabbarFrame
        
        from.tabBarController?.tabBar.isHidden = true
        
        let cover = UIView(frame: WL_SCREEN_BOUNDS)
        
        cover.backgroundColor = .black
        
        cover.alpha = 0
        
        navi.view.superview!.insertSubview(fromBaseView, belowSubview: navi.view)
        
        navi.view.superview!.insertSubview(cover, belowSubview: navi.view)
        
        navi.view.transform = CGAffineTransform.init(translationX: WL_SCREEN_WIDTH, y: 0)
        
        navi.isNavigationBarHidden = to.WL_prefersNavigationBarHidden()
        
        fromBaseView.addSubview(from.view)
        
        fromBaseView.addSubview(topView)
        
        fromBaseView.addSubview(tabbarImageView)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveLinear, animations: {
            
            fromBaseView.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            
            cover.alpha = 0.3
            
            to.navigationController!.view.transform = .identity
            
        }) { (isFinished) in
            
            fromBaseView.removeFromSuperview()
            
            cover.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
    
    open override func pop(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let from = transitionContext.viewController(forKey: .from)!
        
        let to = transitionContext.viewController(forKey: .to)!
        
        guard let navi = to.navigationController else {
            
            fatalError("WLNaviAnimation 请确认有导航!")
        }
        
        let container = transitionContext.containerView
        
        container.addSubview(to.view)
        
        to.view.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        
        let fromConfig: WLNaviAnimationConfig = from.__animation_config!
        
        let duration = transitionDuration(using: transitionContext)
        
        let fromBaseView = UIView(frame: WL_SCREEN_BOUNDS)
        
        let topView = configTopView(config: fromConfig)
        
        let tabbarImageView = UIImageView(image: fromConfig.tabbarImage)
        
        tabbarImageView.frame = fromConfig.tabbarFrame
        
        to.tabBarController?.tabBar.isHidden = true
        
        let cover = UIView(frame: WL_SCREEN_BOUNDS)
        
        cover.backgroundColor = .black
        
        cover.alpha = 0.3
        
        navi.view.superview!.insertSubview(fromBaseView, aboveSubview: navi.view)
        
        navi.view.superview!.insertSubview(cover, aboveSubview: navi.view)
        
        navi.view.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        
        navi.isNavigationBarHidden = true
        
        let toConfig: WLNaviAnimationConfig = to.__animation_config!
        
        let toTopView = configTopView(config: toConfig)
        
        to.view.addSubview(toTopView)
        
        let toTapView = UIImageView(image: toConfig.tabbarImage)
        
        toTapView.frame = toConfig.tabbarFrame
        
        to.view.addSubview(toTapView)
        
        fromBaseView.addSubview(from.view)
        
        fromBaseView.addSubview(topView)
        
        fromBaseView.addSubview(tabbarImageView)
        
        fromBaseView.transform = CGAffineTransform.identity
        
        if let _ = from.interactivePopTransition {
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                
                to.view.transform = CGAffineTransform.identity
                
                cover.alpha = 0.0
                
                fromBaseView.transform = CGAffineTransform.init(translationX: WL_SCREEN_WIDTH, y: 0)
                
                navi.view.transform = CGAffineTransform.identity
                
            }) { (isFinished) in
                
                toTopView.removeFromSuperview()
                
                fromBaseView.removeFromSuperview()
                
                cover.removeFromSuperview()
                
                toTapView.removeFromSuperview()
                
                if transitionContext.transitionWasCancelled {
                    
                    container.addSubview(from.view)
                    
                    transitionContext.completeTransition(false)
                    
                    navi.view.transform = CGAffineTransform.identity
                    
                    navi.isNavigationBarHidden = from.WL_prefersNavigationBarHidden()
                    
                    to.view.transform = CGAffineTransform.identity
                    
                    from.tabBarController?.tabBar.isHidden = from.WL_prefersTabbarHidden()
                } else {
                    
                    to.tabBarController?.tabBar.isHidden = to.WL_prefersTabbarHidden()
                    
                    transitionContext.completeTransition(true)
                    
                    navi.isNavigationBarHidden = to.WL_prefersNavigationBarHidden()
                }
            }
        } else {
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveLinear, animations: {
                
                to.view.transform = CGAffineTransform.identity
                
                cover.alpha = 0.0
                
                fromBaseView.transform = CGAffineTransform.init(translationX: WL_SCREEN_WIDTH, y: 0)
                
                navi.view.transform = CGAffineTransform.identity
                
            }) { (isFinished) in
                
                toTopView.removeFromSuperview()
                
                navi.isNavigationBarHidden = to.WL_prefersNavigationBarHidden()
                
                fromBaseView.removeFromSuperview()
                
                cover.removeFromSuperview()
                
                transitionContext.completeTransition(true)
                
                to.tabBarController?.tabBar.isHidden = to.WL_prefersTabbarHidden()
            }
        }
    }
    
    open func configTopView(config: WLNaviAnimationConfig) -> UIView {
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: WL_SCREEN_WIDTH, height: config.naviFrame.height + config.statusBarFrame.height))
        
        let naviImageView = UIImageView(image: config.naviImage)
        
        naviImageView.frame = config.naviFrame
        
        let img = UIImage.wl_imageFromImage(config.naviImage, inRect: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let statusBar = UIImageView(image: img)
        
        statusBar.frame = config.statusBarFrame
        
        topView.addSubview(statusBar)
        
        topView.addSubview(naviImageView)
        
        topView.isHidden = config.prefersNavigationBarHidden
        
        return topView
    }
}
