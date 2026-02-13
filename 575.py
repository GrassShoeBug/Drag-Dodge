def calculator():
    """实现一个简单的计算器程序"""
    print("=== 简单计算器 ===")
    print("支持的操作: +, -, *, /")
    print("输入 'exit' 退出程序")
    print()
    
    while True:
        try:
            # 获取用户输入
            user_input = input("请输入表达式 (例如: 5 + 3): ").strip()
            
            # 检查是否退出
            if user_input.lower() == 'exit':
                print("感谢使用计算器，再见！")
                break
            
            # 解析输入
            if '+' in user_input:
                parts = user_input.split('+')
                num1 = float(parts[0].strip())
                num2 = float(parts[1].strip())
                result = num1 + num2
                print(f"结果: {num1} + {num2} = {result}\n")
            
            elif '-' in user_input:
                parts = user_input.split('-')
                num1 = float(parts[0].strip())
                num2 = float(parts[1].strip())
                result = num1 - num2
                print(f"结果: {num1} - {num2} = {result}\n")
            
            elif '*' in user_input:
                parts = user_input.split('*')
                num1 = float(parts[0].strip())
                num2 = float(parts[1].strip())
                result = num1 * num2
                print(f"结果: {num1} * {num2} = {result}\n")
            
            elif '/' in user_input:
                parts = user_input.split('/')
                num1 = float(parts[0].strip())
                num2 = float(parts[1].strip())
                if num2 == 0:
                    print("错误: 不能除以0\n")
                else:
                    result = num1 / num2
                    print(f"结果: {num1} / {num2} = {result}\n")
            
            else:
                print("错误: 请输入有效的表达式\n")
        
        except ValueError:
            print("错误: 请输入有效的数字\n")
        except Exception as e:
            print(f"发生错误: {e}\n")


if __name__ == "__main__":
    calculator()
