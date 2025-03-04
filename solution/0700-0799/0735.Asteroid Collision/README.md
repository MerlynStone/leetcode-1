# [735. 行星碰撞](https://leetcode.cn/problems/asteroid-collision)

[English Version](/solution/0700-0799/0735.Asteroid%20Collision/README_EN.md)

## 题目描述

<!-- 这里写题目描述 -->

<p>给定一个整数数组 <code>asteroids</code>，表示在同一行的行星。</p>

<p>对于数组中的每一个元素，其绝对值表示行星的大小，正负表示行星的移动方向（正表示向右移动，负表示向左移动）。每一颗行星以相同的速度移动。</p>

<p>找出碰撞后剩下的所有行星。碰撞规则：两个行星相互碰撞，较小的行星会爆炸。如果两颗行星大小相同，则两颗行星都会爆炸。两颗移动方向相同的行星，永远不会发生碰撞。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [5,10,-5]
<strong>输出：</strong>[5,10]
<b>解释：</b>10 和 -5 碰撞后只剩下 10 。 5 和 10 永远不会发生碰撞。</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [8,-8]
<strong>输出：</strong>[]
<b>解释：</b>8 和 -8 碰撞后，两者都发生爆炸。</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [10,2,-5]
<strong>输出：</strong>[10]
<b>解释：</b>2 和 -5 发生碰撞后剩下 -5 。10 和 -5 发生碰撞后剩下 10 。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= asteroids.length&nbsp;&lt;= 10<sup>4</sup></code></li>
	<li><code>-1000 &lt;= asteroids[i] &lt;= 1000</code></li>
	<li><code>asteroids[i] != 0</code></li>
</ul>

## 解法

<!-- 这里可写通用的实现逻辑 -->

**方法一：栈模拟**

可以类比成左右括号匹配：

-   向右移动的小行星（左括号）：不会引发碰撞，直接入栈
-   向左移动的小行星（右括号）：可能会和之前向右移动的小行星发生碰撞，特殊处理

因为答案需要碰撞后剩下的所有小行星，相当于栈里最后剩下的元素，所以可以直接用数组表示栈

<!-- tabs:start -->

### **Python3**

<!-- 这里可写当前语言的特殊实现逻辑 -->

```python
class Solution:
    def asteroidCollision(self, asteroids: List[int]) -> List[int]:
        ans = []
        for a in asteroids:
            if a > 0:
                ans.append(a)
            else:
                while ans and 0 < ans[-1] < -a:
                    ans.pop()
                if ans and ans[-1] == -a:
                    ans.pop()
                elif not ans or ans[-1] < -a:
                    ans.append(a)
        return ans
```

### **Java**

<!-- 这里可写当前语言的特殊实现逻辑 -->

```java
class Solution {
    public int[] asteroidCollision(int[] asteroids) {
        Deque<Integer> d = new ArrayDeque<>();
        for (int a : asteroids) {
            if (a > 0) {
                d.offerLast(a);
            } else {
                while (!d.isEmpty() && d.peekLast() > 0 && d.peekLast() < -a) {
                    d.pollLast();
                }
                if (!d.isEmpty() && d.peekLast() == -a) {
                    d.pollLast();
                } else if (d.isEmpty() || d.peekLast() < -a) {
                    d.offerLast(a);
                }
            }
        }
        return d.stream().mapToInt(Integer::valueOf).toArray();
    }
}
```

### **C++**

```cpp
class Solution {
public:
    vector<int> asteroidCollision(vector<int>& asteroids) {
        vector<int> ans;
        for (int a : asteroids) {
            if (a > 0) {
                ans.push_back(a);
            } else {
                while (!ans.empty() && ans.back() > 0 && ans.back() < -a) {
                    ans.pop_back();
                }
                if (!ans.empty() && ans.back() == -a) {
                    ans.pop_back();
                } else if (ans.empty() || ans.back() < -a) {
                    ans.push_back(a);
                }
            }
        }
        return ans;
    }
};
```

### **Rust**

```rust
impl Solution {
    #[allow(dead_code)]
    pub fn asteroid_collision(asteroids: Vec<i32>) -> Vec<i32> {
        let mut ret_stack = Vec::new();

        for &a in &asteroids {
            if ret_stack.is_empty() {
                ret_stack.push(a);
                continue;
            }
            if a > 0 {
                ret_stack.push(a);
                continue;
            }
            // Otherwise, peek the top element in the current stack
            if a < 0 {
                if *ret_stack.last().unwrap() < 0 {
                    ret_stack.push(a);
                    continue;
                }
                let mut explode_flag = false;
                while !ret_stack.is_empty() && *ret_stack.last().unwrap() > 0 {
                    let cur_res = *ret_stack.last().unwrap() + a;
                    if cur_res < 0 {
                        // |a| > |top()|
                        assert_ne!(ret_stack.pop(), None);
                    } else if cur_res == 0 {
                        // |a| == |top()|
                        explode_flag = true;
                        assert_ne!(ret_stack.pop(), None);
                        break;
                    } else {
                        // |a| < |top()|
                        explode_flag = true;
                        break;
                    }
                }
                if !explode_flag {
                    ret_stack.push(a);
                }
                continue;
            }
            assert!(false); // This is impossible
        }

        ret_stack
    }
}
```

### **Go**

```go
func asteroidCollision(asteroids []int) []int {
	var ans []int
	for _, a := range asteroids {
		if a > 0 {
			ans = append(ans, a)
		} else {
			for len(ans) > 0 && ans[len(ans)-1] > 0 && ans[len(ans)-1] < -a {
				ans = ans[:len(ans)-1]
			}
			if len(ans) > 0 && ans[len(ans)-1] == -a {
				ans = ans[:len(ans)-1]
			} else if len(ans) == 0 || ans[len(ans)-1] < -a {
				ans = append(ans, a)
			}
		}
	}
	return ans
}
```

### TypeScript

```ts
function asteroidCollision(asteroids: number[]): number[] {
    const ans: number[] = [];
    for (const a of asteroids) {
        if (a > 0) {
            ans.push(a);
        } else {
            while (ans.length && 0 < ans[ans.length - 1] && ans[ans.length - 1] < -a) {
                ans.pop();
            }
            if (ans.length && ans[ans.length - 1] === -a) {
                ans.pop();
            } else if (!ans.length || ans[ans.length - 1] < -a) {
                ans.push(a);
            }
        }
    }
    return ans;
}
```

### **...**

```

```

<!-- tabs:end -->
