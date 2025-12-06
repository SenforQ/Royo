#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
重组 figure 文件夹结构：
1. 将子文件夹中的文件提取到 figure 根目录
2. 使用 UUID 重命名文件
3. 更新 NABI_Chat.json 中的路径引用
"""

import os
import json
import shutil
import uuid
from pathlib import Path

# 项目根目录
PROJECT_ROOT = Path(__file__).parent
FIGURE_DIR = PROJECT_ROOT / "assets" / "figure"
JSON_FILE = PROJECT_ROOT / "assets" / "NABI_Chat.json"

def get_file_extension(filename):
    """获取文件扩展名"""
    return os.path.splitext(filename)[1]

def reorganize_files():
    """重组文件并生成路径映射"""
    # 路径映射：旧路径 -> 新路径
    path_mapping = {}
    
    # 遍历所有子文件夹（1-20）
    for folder_num in range(1, 21):
        subfolder = FIGURE_DIR / str(folder_num)
        
        if not subfolder.exists():
            print(f"警告: 文件夹 {subfolder} 不存在，跳过")
            continue
        
        # 获取子文件夹中的所有文件（排除 .DS_Store）
        files = [f for f in subfolder.iterdir() if f.is_file() and f.name != ".DS_Store"]
        
        for old_file in files:
            # 生成新的文件名（使用 UUID + 原扩展名）
            extension = get_file_extension(old_file.name)
            new_filename = f"{uuid.uuid4()}{extension}"
            new_file = FIGURE_DIR / new_filename
            
            # 移动并重命名文件
            shutil.move(str(old_file), str(new_file))
            print(f"移动: {old_file} -> {new_file}")
            
            # 记录路径映射
            old_path = f"assets/figure/{folder_num}/{old_file.name}"
            new_path = f"assets/figure/{new_filename}"
            path_mapping[old_path] = new_path
    
    return path_mapping

def update_json_file(path_mapping):
    """更新 JSON 文件中的路径引用"""
    # 读取 JSON 文件
    with open(JSON_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # 递归更新 JSON 中的所有路径
    def update_paths(obj):
        if isinstance(obj, dict):
            for key, value in obj.items():
                if isinstance(value, str):
                    # 如果是路径字符串，尝试替换
                    if value in path_mapping:
                        obj[key] = path_mapping[value]
                else:
                    update_paths(value)
        elif isinstance(obj, list):
            for i, item in enumerate(obj):
                if isinstance(item, str):
                    # 如果是路径字符串，尝试替换
                    if item in path_mapping:
                        obj[i] = path_mapping[item]
                else:
                    update_paths(item)
    
    update_paths(data)
    
    # 保存更新后的 JSON 文件
    with open(JSON_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"\n已更新 JSON 文件: {JSON_FILE}")

def cleanup_empty_folders():
    """清理空的子文件夹"""
    for folder_num in range(1, 21):
        subfolder = FIGURE_DIR / str(folder_num)
        if subfolder.exists():
            # 检查文件夹是否为空（除了 .DS_Store）
            files = [f for f in subfolder.iterdir() if f.name != ".DS_Store"]
            if not files:
                # 删除 .DS_Store（如果存在）
                ds_store = subfolder / ".DS_Store"
                if ds_store.exists():
                    ds_store.unlink()
                # 删除空文件夹
                subfolder.rmdir()
                print(f"删除空文件夹: {subfolder}")

def main():
    """主函数"""
    print("开始重组 figure 文件夹...")
    print(f"项目根目录: {PROJECT_ROOT}")
    print(f"Figure 目录: {FIGURE_DIR}")
    print(f"JSON 文件: {JSON_FILE}\n")
    
    # 检查目录是否存在
    if not FIGURE_DIR.exists():
        print(f"错误: {FIGURE_DIR} 不存在")
        return
    
    if not JSON_FILE.exists():
        print(f"错误: {JSON_FILE} 不存在")
        return
    
    # 重组文件并获取路径映射
    print("=" * 50)
    print("步骤 1: 移动并重命名文件")
    print("=" * 50)
    path_mapping = reorganize_files()
    
    print(f"\n共处理 {len(path_mapping)} 个文件")
    
    # 更新 JSON 文件
    print("\n" + "=" * 50)
    print("步骤 2: 更新 JSON 文件中的路径")
    print("=" * 50)
    update_json_file(path_mapping)
    
    # 清理空文件夹
    print("\n" + "=" * 50)
    print("步骤 3: 清理空文件夹")
    print("=" * 50)
    cleanup_empty_folders()
    
    print("\n" + "=" * 50)
    print("完成！所有文件已重组并更新路径引用")
    print("=" * 50)

if __name__ == "__main__":
    main()

