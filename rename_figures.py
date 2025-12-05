#!/usr/bin/env python3
import os
import shutil
from pathlib import Path
import subprocess

def is_image_file(filename):
    """检查是否为图片文件"""
    image_extensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp']
    return any(filename.lower().endswith(ext) for ext in image_extensions)

def is_video_file(filename):
    """检查是否为视频文件"""
    video_extensions = ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv']
    return any(filename.lower().endswith(ext) for ext in video_extensions)

def convert_to_webp(input_path, output_path):
    """将图片转换为webp格式"""
    try:
        # 使用sips命令（macOS自带）
        result = subprocess.run(
            ['sips', '-s', 'format', 'webp', '--out', str(output_path), str(input_path)],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            return True
        else:
            print(f"Error converting {input_path}: {result.stderr}")
            return False
    except Exception as e:
        print(f"Error converting {input_path}: {e}")
        return False

def extract_video_thumbnail(video_path, thumbnail_path):
    """从视频提取封面图"""
    try:
        # 使用ffmpeg直接提取为webp格式
        result = subprocess.run(
            ['ffmpeg', '-i', str(video_path), '-ss', '00:00:01', '-vframes', '1', 
             '-vf', 'scale=800:-1', '-f', 'webp', '-y', str(thumbnail_path)],
            capture_output=True,
            text=True
        )
        if result.returncode == 0 and thumbnail_path.exists():
            return True
        else:
            print(f"  警告: 无法提取视频封面: {result.stderr}")
            return False
    except Exception as e:
        print(f"  警告: 提取封面时出错: {e}")
        return False

def process_figure_folder(folder_path, folder_name):
    """处理单个figure文件夹"""
    folder = Path(folder_path)
    if not folder.exists() or not folder.is_dir():
        return
    
    # 获取所有文件
    all_files = [f for f in folder.iterdir() if f.is_file() and not f.name.startswith('.')]
    
    # 分离图片和视频
    image_files = [f for f in all_files if is_image_file(f.name)]
    video_files = [f for f in all_files if is_video_file(f.name)]
    
    # 按文件名排序
    image_files.sort(key=lambda x: x.name)
    video_files.sort(key=lambda x: x.name)
    
    print(f"\n处理文件夹 {folder_name}:")
    print(f"  找到 {len(image_files)} 个图片文件")
    print(f"  找到 {len(video_files)} 个视频文件")
    
    # 处理图片文件
    for idx, img_file in enumerate(image_files, start=1):
        old_path = img_file
        new_name = f"character_{folder_name}_img_{idx}.webp"
        new_path = folder / new_name
        
        # 如果已经是webp格式，直接重命名
        if img_file.suffix.lower() == '.webp':
            if old_path.name != new_name:
                old_path.rename(new_path)
                print(f"  重命名图片: {old_path.name} -> {new_name}")
        else:
            # 需要转换为webp
            temp_webp = folder / f"temp_{idx}.webp"
            if convert_to_webp(old_path, temp_webp):
                if old_path.exists():
                    old_path.unlink()  # 删除原文件
                temp_webp.rename(new_path)
                print(f"  转换并重命名图片: {old_path.name} -> {new_name}")
            else:
                print(f"  警告: 无法转换 {old_path.name}")
    
    # 处理视频文件
    for idx, video_file in enumerate(video_files, start=1):
        old_path = video_file
        new_name = f"character_{folder_name}_video_{idx}.mp4"
        new_path = folder / new_name
        
        # 重命名视频文件
        if old_path.name != new_name:
            old_path.rename(new_path)
            print(f"  重命名视频: {old_path.name} -> {new_name}")
        
        # 提取封面图
        thumbnail_name = f"character_{folder_name}_video_{idx}.webp"
        thumbnail_path = folder / thumbnail_name
        
        if not thumbnail_path.exists():
            if extract_video_thumbnail(new_path, thumbnail_path):
                print(f"  提取视频封面: {thumbnail_name}")
            else:
                print(f"  警告: 无法提取 {new_path.name} 的封面")

def main():
    """主函数"""
    base_path = Path("/Users/gjm4senfor/Desktop/Royo/assets/figure")
    
    if not base_path.exists():
        print(f"错误: 路径不存在 {base_path}")
        return
    
    # 遍历所有文件夹（1-20）
    for folder_num in range(1, 21):
        folder_name = str(folder_num)
        folder_path = base_path / folder_name
        
        if folder_path.exists() and folder_path.is_dir():
            process_figure_folder(folder_path, folder_name)
        else:
            print(f"跳过不存在的文件夹: {folder_name}")
    
    print("\n处理完成！")

if __name__ == "__main__":
    main()

