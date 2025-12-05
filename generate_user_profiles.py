#!/usr/bin/env python3
import json
import random
from pathlib import Path

# MBTI personality types (without identifiers)
personalities = [
    {
        "traits": ["analytical", "logical", "strategic", "independent"],
        "interests": ["storytelling", "voice acting", "narrating adventures"]
    },
    {
        "traits": ["creative", "imaginative", "insightful", "passionate"],
        "interests": ["dramatic narration", "character voices", "epic tales"]
    },
    {
        "traits": ["practical", "organized", "reliable", "detail-oriented"],
        "interests": ["structured storytelling", "clear narration", "educational content"]
    },
    {
        "traits": ["warm", "empathetic", "supportive", "harmonious"],
        "interests": ["heartwarming stories", "emotional narration", "inspiring tales"]
    },
    {
        "traits": ["adventurous", "spontaneous", "energetic", "curious"],
        "interests": ["action-packed stories", "dynamic narration", "thrilling adventures"]
    },
    {
        "traits": ["artistic", "expressive", "enthusiastic", "vibrant"],
        "interests": ["creative storytelling", "expressive voices", "artistic narratives"]
    },
    {
        "traits": ["thoughtful", "reserved", "deep", "contemplative"],
        "interests": ["philosophical stories", "thoughtful narration", "deep narratives"]
    },
    {
        "traits": ["charismatic", "confident", "inspiring", "motivational"],
        "interests": ["inspiring stories", "powerful narration", "motivational content"]
    },
    {
        "traits": ["gentle", "peaceful", "adaptable", "flexible"],
        "interests": ["peaceful stories", "calm narration", "soothing tales"]
    },
    {
        "traits": ["innovative", "visionary", "original", "unique"],
        "interests": ["unique storytelling", "innovative narration", "original content"]
    },
    {
        "traits": ["loyal", "dedicated", "committed", "steadfast"],
        "interests": ["loyalty stories", "dedicated narration", "committed storytelling"]
    },
    {
        "traits": ["optimistic", "cheerful", "positive", "uplifting"],
        "interests": ["positive stories", "cheerful narration", "uplifting tales"]
    },
    {
        "traits": ["mysterious", "intriguing", "captivating", "enigmatic"],
        "interests": ["mystery stories", "intriguing narration", "captivating tales"]
    },
    {
        "traits": ["playful", "humorous", "entertaining", "fun"],
        "interests": ["funny stories", "humorous narration", "entertaining content"]
    },
    {
        "traits": ["wise", "knowledgeable", "experienced", "insightful"],
        "interests": ["wise stories", "knowledgeable narration", "insightful tales"]
    },
    {
        "traits": ["bold", "daring", "fearless", "courageous"],
        "interests": ["bold stories", "daring narration", "courageous tales"]
    }
]

nicknames = [
    "StoryTeller", "VoiceMaster", "NarratorPro", "TaleWeaver", "StoryCraft",
    "VoiceArtist", "NarrativeGenius", "TaleSpinner", "StoryVoice", "NarratorElite",
    "VoiceCraft", "StoryGenius", "TaleMaster", "NarrativePro", "VoiceWeaver",
    "StoryElite", "TaleVoice", "NarratorCraft", "VoiceGenius", "StorySpinner"
]

def generate_background(personality):
    """生成角色背景介绍"""
    traits = personality["traits"]
    interests = personality["interests"]
    
    templates = [
        f"A {traits[0]} storyteller who loves {interests[0]}. Known for {traits[1]} approach and passion for {interests[1]}. Always ready to share captivating narratives.",
        f"Passionate about {interests[0]} with a {traits[0]} style. Brings {traits[1]} perspective to every story, making each tale unique and engaging.",
        f"An enthusiast of {interests[0]} with {traits[0]} nature. Combines {traits[1]} thinking with creative storytelling to deliver memorable experiences.",
        f"Loves {interests[0]} and {interests[1]}. With a {traits[0]} personality, brings fresh perspectives to narratives that captivate audiences.",
        f"A {traits[0]} voice artist passionate about {interests[0]}. Known for {traits[1]} delivery and ability to bring stories to life through narration."
    ]
    
    text = random.choice(templates)
    # Ensure length is 100-200 characters
    while len(text) < 100:
        text += f" Enjoys exploring {interests[2] if len(interests) > 2 else interests[0]} and connecting with audiences."
    if len(text) > 200:
        text = text[:197] + "..."
    return text

def generate_greeting(personality):
    """生成打招呼文案"""
    traits = personality["traits"]
    
    templates = [
        f"Hey there! I'm excited to share some amazing stories with you. Ready for an adventure?",
        f"Hello! Welcome to my storytelling world. I've got some incredible tales waiting for you!",
        f"Hi! Thanks for stopping by. I love narrating stories and I think you'll enjoy what I have to share.",
        f"Greetings! I'm thrilled you're here. Let's dive into some fascinating narratives together!",
        f"Hey! Welcome! I'm passionate about storytelling and I can't wait to share my favorite tales with you.",
        f"Hello friend! Ready to explore some captivating stories? I've got plenty to share!",
        f"Hi there! I'm so glad you're here. Let's embark on a storytelling journey together!",
        f"Welcome! I love connecting through stories. I think you'll enjoy what I have prepared!"
    ]
    
    text = random.choice(templates)
    # Ensure length is 100-200 characters
    if len(text) < 100:
        text += f" My {traits[0]} style brings something special to every narrative."
    if len(text) > 200:
        text = text[:197] + "..."
    return text

def generate_motto(personality):
    """生成自我介绍"""
    traits = personality["traits"]
    interests = personality["interests"]
    
    mottos = [
        f"Bringing stories to life through {interests[0]}",
        f"Every story deserves a {traits[0]} voice",
        f"Passionate about {interests[0]} and {interests[1]}",
        f"Creating magic through {traits[0]} storytelling",
        f"Where {traits[0]} meets creative narration"
    ]
    
    return random.choice(mottos)

def check_sensitive_words(text):
    """检查敏感词汇"""
    sensitive_words = [
        "government", "legal", "law", "hospital", "medical", "doctor", "nurse",
        "police", "court", "judge", "lawyer", "attorney", "clinic", "surgery",
        "president", "minister", "official", "authority", "regulation", "policy"
    ]
    text_lower = text.lower()
    for word in sensitive_words:
        if word in text_lower:
            return True
    return False

def get_files_for_folder(folder_num):
    """获取文件夹中的文件列表"""
    folder_path = Path(f"/Users/gjm4senfor/Desktop/Royo/assets/figure/{folder_num}")
    
    if not folder_path.exists():
        return [], [], []
    
    images = sorted([f for f in folder_path.iterdir() if f.name.startswith(f"character_{folder_num}_img_") and f.suffix == ".webp"])
    videos = sorted([f for f in folder_path.iterdir() if f.name.startswith(f"character_{folder_num}_video_") and f.suffix == ".mp4"])
    thumbnails = sorted([f for f in folder_path.iterdir() if f.name.startswith(f"character_{folder_num}_video_") and f.suffix == ".webp" and "img" not in f.name])
    
    return images, videos, thumbnails

def main():
    """主函数"""
    profiles = []
    
    for folder_num in range(1, 21):
        personality = random.choice(personalities)
        nickname = nicknames[folder_num - 1]
        
        # 生成内容
        background = generate_background(personality)
        greeting = generate_greeting(personality)
        motto = generate_motto(personality)
        
        # 检查敏感词汇
        while check_sensitive_words(background) or check_sensitive_words(greeting) or check_sensitive_words(motto):
            personality = random.choice(personalities)
            background = generate_background(personality)
            greeting = generate_greeting(personality)
            motto = generate_motto(personality)
        
        # 获取文件
        images, videos, thumbnails = get_files_for_folder(folder_num)
        
        # 构建路径数组
        photo_array = [f"assets/figure/{folder_num}/{img.name}" for img in images]
        video_array = [f"assets/figure/{folder_num}/{vid.name}" for vid in videos]
        thumbnail_array = [f"assets/figure/{folder_num}/{thumb.name}" for thumb in thumbnails]
        
        # 如果没有找到thumbnail，使用video文件名生成（实际文件名是character_x_video_y.webp）
        if not thumbnail_array and videos:
            thumbnail_array = [f"assets/figure/{folder_num}/character_{folder_num}_video_{i+1}.webp" for i in range(len(videos))]
        
        profile = {
            "RoroNickName": nickname,
            "RoroUserIcon": f"assets/figure/{folder_num}/character_{folder_num}_img_1.webp",
            "RoroShowPhotoArray": photo_array,
            "RoroShowVideoArray": video_array,
            "RoroShowThumbnailArray": thumbnail_array,
            "RoroShowMotto": motto,
            "RoroShowFollowNum": random.randint(2, 10),
            "RoroShowLike": random.randint(5, 15),
            "RoroShowSayhi": greeting,
            "RoroShowBackground": background
        }
        
        profiles.append(profile)
    
    # 输出JSON
    output = json.dumps(profiles, indent=2, ensure_ascii=False)
    print(output)
    
    # 保存到文件
    with open("/Users/gjm4senfor/Desktop/Royo/user_profiles.json", "w", encoding="utf-8") as f:
        f.write(output)
    
    print(f"\n已生成20个用户资料并保存到 user_profiles.json")

if __name__ == "__main__":
    main()

