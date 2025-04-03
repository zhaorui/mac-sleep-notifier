#!/bin/zsh

# 确保在git仓库中运行
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "错误：请在git仓库目录中运行此脚本"
    exit 1
fi

# 获取最新的标签
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
if [[ $? -eq 0 ]]; then
    echo "当前最新的标签是: $latest_tag"
else
    echo "当前没有标签"
    latest_tag="v0.0.0"
fi

# 提示输入新标签
echo -n "请输入新的标签 (建议格式 vX.Y.Z): "
read new_tag

# 验证标签格式（可选）
if [[ ! $new_tag =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "警告：标签格式可能不符合语义化版本规范 (vX.Y.Z)"
    echo -n "确定要继续吗？(y/n): "
    read confirm
    if [[ $confirm != "y" && $confirm != "Y" ]]; then
        exit 1
    fi
fi

# 创建并推送标签
echo "创建并推送标签 $new_tag..."
git tag $new_tag
git push origin $new_tag

# 检查推送是否成功
if [[ $? -ne 0 ]]; then
    echo "错误：推送标签失败"
    exit 1
fi

# 立即同步到pkg.go.dev
echo "正在同步到pkg.go.dev..."
curl -s "https://proxy.golang.org/github.com/zhaorui/mac-sleep-notifier/@v/${new_tag}.info" > /dev/null
if [[ $? -eq 0 ]]; then
    echo "成功！新版本 $new_tag 已提交"
    echo "请稍后访问 https://pkg.go.dev/github.com/zhaorui/mac-sleep-notifier@$new_tag 检查结果"
else
    echo "警告：同步到pkg.go.dev可能失败"
fi
