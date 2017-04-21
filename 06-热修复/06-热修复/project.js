defineClass('ViewController', {
            
//            viewDidLoad:function()
//            {
//               self.super().viewDidLoad()
//            
//               
//            },
            
            
            test1:function()
            {
               //创建一个按钮，并且设置坐标
               var button = require('UIButton').alloc().initWithFrame({x:30, y:50, width:200, height:200})
               //设置背景颜色
               button.setBackgroundColor(require('UIColor').redColor())
                button.addTarget_action_forControlEvents(self,'buttonClick:',1 <<  6)
               //添加到父视图
               self.view().addSubview(button)
            
            },
            
            //按钮点击
            buttonClick:function(obj)
            {
                obj.setBackgroundColor(require('UIColor').greenColor())
            
            //进入testViewController
            var testCtrl = require('TestViewController').alloc().init()
            //设置背景颜色
            testCtrl.view().setBackgroundColor(require('UIColor').purpleColor())
            testCtrl.setTitle('详情')
            self.navigationController().pushViewController_animated(testCtrl,true)
            
            /*
            var alertView = require('UIAlertView')
            .alloc()
            .initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles(
                                                                                "Alert",
                                                                                "",
                                                                                self, 
                                                                                "OK", 
                                                                                null
                                                                                )
            alertView.show()
             */
            }
            
})

//定义一个新的类
defineClass('TestViewController: UIViewController',
            {
            
            
            })
