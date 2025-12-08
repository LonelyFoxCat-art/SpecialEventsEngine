/// @desc 二叉树数据结构（支持普通 BST 与 AVL 自平衡模式）
/// 
/// 本结构体实现了一个功能完整的二叉搜索树（Binary Search Tree），
/// 并可选启用 AVL 自平衡模式，确保树的高度始终保持 O(log n)，
/// 从而保证插入、删除、查找等操作的高效性。
/// 
/// 特性：
/// - 支持重复值过滤（插入相同值将被忽略）
/// - 提供前序、中序、后序遍历（返回数组）
/// - 支持查询（search）、高度（height）、节点数（size）、平衡性检查（is_balanced）
/// - AVL 模式下自动维护平衡（通过 LL/LR/RR/RL 四种旋转）
/// - 所有逻辑封装在构造函数内部，无外部依赖
/// 
/// 使用方式：
///   var bst = new BinaryTree(false); // 普通二叉搜索树
///   var avl = new BinaryTree(true);  // AVL 自平衡树
/// 
///   tree.insert(value);
///   tree.delete(value);
///   tree.search(value);
///   tree.inorder();   // 返回排序数组
///   tree.preorder();
///   tree.postorder();
///   tree.height();
///   tree.size();
///   tree.is_balanced();
/// 
/// 注意事项：
/// - 值类型应为可比较的标量（如 real 或 string）
/// - AVL 删除已完整实现，支持所有平衡修复情形
/// - 不支持 undefined 作为有效节点值
/// 
/// 适用场景：
///   - 动态有序数据管理
///   - 游戏中的排行榜、任务优先级队列
///   - 程序化生成中的区间划分
///   - 需要高效范围查询或排序遍历的系统
/// 
/// @param {bool} [_avl_mode=false] 是否启用 AVL 自平衡模式
/// @constructor
function BinaryTree(_avl_mode = false) constructor {
    self.avl_mode = _avl_mode;

    // 节点结构
    self.TreeNode = function(_value) {
        return {
            value: _value,
            left: undefined,
            right: undefined,
            height: 1
        };
    };

    self.root = undefined;

    // ========== 基础辅助 ==========
    self._max = function(a, b) { return (a > b) ? a : b; };
    self._height = function(n) { return (n == undefined) ? 0 : n.height; };
    self._update_height = function(n) {
        if (n != undefined) n.height = 1 + self._max(self._height(n.left), self._height(n.right));
    };
    self._get_balance = function(n) { 
        return (n == undefined) ? 0 : self._height(n.left) - self._height(n.right); 
    };

    // ========== 旋转 ==========
    self._rotate_right = function(_y) {
        var _x = _y.left;
        var t2 = _x.right;
        _x.right = _y;
        _y.left = t2;
        self._update_height(_y);
        self._update_height(_x);
        return _x;
    };
    self._rotate_left = function(_x) {
        var _y = _x.right;
        var t2 = _y.left;
        _y.left = _x;
        _x.right = t2;
        self._update_height(_x);
        self._update_height(_y);
        return _y;
    };

    // ========== 插入（AVL）==========
    self.insert = function(_value) {
        if (self.avl_mode) {
            self.root = self._insert_avl(self.root, _value);
        } else {
            self.root = self._insert_bst(self.root, _value);
        }
    };
    self._insert_bst = function(n, v) {
        if (!n) return self.TreeNode(v);
        if (v < n.value) n.left = self._insert_bst(n.left, v);
        else if (v > n.value) n.right = self._insert_bst(n.right, v);
        self._update_height(n);
        return n;
    };
    self._insert_avl = function(n, v) {
        if (!n) return self.TreeNode(v);
        if (v < n.value) n.left = self._insert_avl(n.left, v);
        else if (v > n.value) n.right = self._insert_avl(n.right, v);
        else return n;

        self._update_height(n);
        var bal = self._get_balance(n);

        // Left Left
        if (bal > 1 && v < n.left.value) return self._rotate_right(n);
        // Right Right
        if (bal < -1 && v > n.right.value) return self._rotate_left(n);
        // Left Right
        if (bal > 1 && v > n.left.value) {
            n.left = self._rotate_left(n.left);
            return self._rotate_right(n);
        }
        // Right Left
        if (bal < -1 && v < n.right.value) {
            n.right = self._rotate_right(n.right);
            return self._rotate_left(n);
        }
        return n;
    };

    // ========== 删除（核心：AVL 删除）==========
    self.remove = function(_value) {
        if (self.avl_mode) {
            self.root = self._remove_avl(self.root, _value);
        } else {
            self.root = self._remove_bst(self.root, _value);
        }
    };

    // AVL 删除主函数
    self._remove_avl = function(n, v) {
        // 1. 标准 BST 删除
        if (!n) return n;
        if (v < n.value) {
            n.left = self._remove_avl(n.left, v);
        } else if (v > n.value) {
            n.right = self._remove_avl(n.right, v);
        } else {
            // 找到要删除的节点
            if (!n.left || !n.right) {
                var temp = n.left ? n.left : n.right;
                if (!temp) {
                    // 无子节点
                    temp = n;
                    n = undefined;
                } else {
                    // 一个子节点
                    n = temp; // 直接替换
                }
            } else {
                // 两个子节点：找中序后继（右子树最小）
                var temp = self._min_node(n.right);
                n.value = temp.value;
                n.right = self._remove_avl(n.right, temp.value);
            }
        }

        if (!n) return n; // 被删的是叶子

        // 2. 更新高度
        self._update_height(n);

        // 3. 检查平衡
        var bal = self._get_balance(n);

        // Left Left
        if (bal > 1 && self._get_balance(n.left) >= 0) {
            return self._rotate_right(n);
        }
        // Left Right
        if (bal > 1 && self._get_balance(n.left) < 0) {
            n.left = self._rotate_left(n.left);
            return self._rotate_right(n);
        }
        // Right Right
        if (bal < -1 && self._get_balance(n.right) <= 0) {
            return self._rotate_left(n);
        }
        // Right Left
        if (bal < -1 && self._get_balance(n.right) > 0) {
            n.right = self._rotate_right(n.right);
            return self._rotate_left(n);
        }

        return n;
    };

    // 普通 BST 删除（非 AVL 模式用）
    self._remove_bst = function(n, v) {
        if (!n) return n;
        if (v < n.value) n.left = self._remove_bst(n.left, v);
        else if (v > n.value) n.right = self._remove_bst(n.right, v);
        else {
            if (!n.left) return n.right;
            if (!n.right) return n.left;
            var succ = self._min_node(n.right);
            n.value = succ.value;
            n.right = self._remove_bst(n.right, succ.value);
        }
        self._update_height(n);
        return n;
    };

    self._min_node = function(n) {
        while (n && n.left) n = n.left;
        return n;
    };

    // ========== 遍历 ==========
    self.inorder = function() { var r = []; self._inorder(self.root, r); return r; };
    self.preorder = function() { var r = []; self._preorder(self.root, r); return r; };
    self.postorder = function() { var r = []; self._postorder(self.root, r); return r; };
    self._inorder = function(n, r) { if (n) { self._inorder(n.left, r); array_push(r, n.value); self._inorder(n.right, r); } };
    self._preorder = function(n, r) { if (n) { array_push(r, n.value); self._preorder(n.left, r); self._preorder(n.right, r); } };
    self._postorder = function(n, r) { if (n) { self._postorder(n.left, r); self._postorder(n.right, r); array_push(r, n.value); } };

    // ========== 查询与属性 ==========
    self.search = function(v) {
        var cur = self.root;
        while (cur) {
            if (v == cur.value) return true;
            cur = v < cur.value ? cur.left : cur.right;
        }
        return false;
    };
    self.height = function() { return self._height(self.root); };
    self.size = function() { return self._size(self.root); };
    self._size = function(n) { return n ? 1 + self._size(n.left) + self._size(n.right) : 0; };
    self.is_balanced = function() { return self._check_bal(self.root) != -1; };
    self._check_bal = function(n) {
        if (!n) return 0;
        var lh = self._check_bal(n.left);
        if (lh == -1) return -1;
        var rh = self._check_bal(n.right);
        if (rh == -1) return -1;
        if (abs(lh - rh) > 1) return -1;
        return 1 + self._max(lh, rh);
    };
}