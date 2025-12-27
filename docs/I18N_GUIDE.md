# 多语言国际化指南 (Internationalization Guide)

本文档说明了 PromptFill 项目的多语言文字架构及使用方法。

## 架构概述 (Architecture Overview)

### 1. 翻译文件位置 (Translation Files Location)

所有界面文本的翻译都集中在一个文件中：

```
src/constants/translations.js
```

### 2. 支持的语言 (Supported Languages)

当前支持以下语言：
- **中文 (Chinese)**: `cn`
- **英文 (English)**: `en`

### 3. 翻译文件结构 (Translation File Structure)

```javascript
// src/constants/translations.js
export const TRANSLATIONS = {
  cn: {
    // 导航和标签页
    home: "主页",
    templates: "模版列表",
    editor: "模版编辑",
    banks: "词库",
    
    // 通用操作
    undo: "撤消",
    redo: "重做",
    
    // ... 更多翻译
  },
  en: {
    // Navigation and Tabs
    home: "Home",
    templates: "Templates",
    editor: "Editor",
    banks: "Banks",
    
    // Common Actions
    undo: "Undo",
    redo: "Redo",
    
    // ... more translations
  }
};
```

## 如何使用翻译 (How to Use Translations)

### 在组件中使用翻译函数 (Using Translation Function in Components)

所有组件都通过 `t()` 函数来获取翻译文本：

```javascript
// 在组件中
const MyComponent = ({ t, language }) => {
  return (
    <div>
      <h1>{t('home')}</h1>
      <button>{t('undo')}</button>
    </div>
  );
};
```

### 翻译函数的实现 (Translation Function Implementation)

在 `App.jsx` 中定义的翻译函数：

```javascript
const t = (key, params = {}) => {
  let str = TRANSLATIONS[language][key] || key;
  Object.keys(params).forEach(k => {
    str = str.replace(`{{${k}}}`, params[k]);
  });
  return str;
};
```

### 带参数的翻译 (Translations with Parameters)

某些翻译需要动态参数：

```javascript
// 翻译文件中
cn: {
  confirm_delete_bank: "确定要删除\"{{name}}\"整个词库吗？",
}

// 使用时
t('confirm_delete_bank', { name: bankName })
```

## 添加新的翻译 (Adding New Translations)

### 步骤 1: 在翻译文件中添加键值对 (Step 1: Add Key-Value Pairs)

在 `src/constants/translations.js` 中同时添加中英文翻译：

```javascript
export const TRANSLATIONS = {
  cn: {
    // ... 现有翻译
    new_feature: "新功能",
  },
  en: {
    // ... existing translations
    new_feature: "New Feature",
  }
};
```

### 步骤 2: 在组件中使用新的翻译键 (Step 2: Use New Translation Key)

```javascript
<button>{t('new_feature')}</button>
```

## 翻译分类 (Translation Categories)

翻译按功能分类组织，便于管理和查找：

### 1. 导航和标签页 (Navigation and Tabs)
- `home`, `templates`, `editor`, `banks`, `details`

### 2. 通用操作 (Common Actions)
- `undo`, `redo`, `insert`, `delete`, `rename`, `duplicate`

### 3. 联动组相关 (Linkage Group Related)
- `linkage_group`, `set_linkage_group`, `unlink`

### 4. 主题模式 (Theme Mode)
- `light_mode`, `dark_mode`

### 5. 模版管理 (Template Management)
- `template_management`, `new_template`, `edit_mode`, `preview_mode`

### 6. 词库配置 (Bank Configuration)
- `bank_config`, `add_bank_group`, `manage_categories`

### 7. 导入导出 (Import/Export)
- `export_template`, `import_template`, `export_all_templates`

### 8. 图片管理 (Image Management)
- `upload_image`, `change_image`, `image_url`

## 多语言内容 (Multilingual Content)

### 模板和数据的多语言支持 (Multilingual Support for Templates and Data)

模板名称和内容支持多语言对象：

```javascript
{
  id: "tpl_example",
  name: { 
    cn: "示例模板", 
    en: "Example Template" 
  },
  content: { 
    cn: "中文内容...", 
    en: "English content..." 
  },
  language: ["cn", "en"]
}
```

### 辅助函数 (Helper Functions)

使用 `getLocalized()` 函数获取本地化文本：

```javascript
import { getLocalized } from '../utils/helpers';

// 自动根据当前语言返回对应文本
const title = getLocalized(template.name, language);
```

## 语言切换 (Language Switching)

### 自动检测系统语言 (Auto-detect System Language)

应用启动时自动检测系统语言：

```javascript
export const getSystemLanguage = () => {
  if (typeof window === 'undefined') return 'cn';
  const lang = (navigator.language || navigator.languages?.[0] || 'zh-CN').toLowerCase();
  return lang.startsWith('zh') ? 'cn' : 'en';
};
```

### 手动切换语言 (Manual Language Switch)

用户可以通过侧边栏的语言按钮切换界面语言。

## 最佳实践 (Best Practices)

### 1. 避免硬编码文本 (Avoid Hardcoded Text)

❌ 不推荐：
```javascript
<button>主页</button>
<button title="撤消">Undo</button>
```

✅ 推荐：
```javascript
<button>{t('home')}</button>
<button title={t('undo')}>Undo</button>
```

### 2. 保持翻译键简洁明了 (Keep Translation Keys Clear and Concise)

- 使用下划线分隔单词：`template_management`
- 使用描述性名称：`confirm_delete_template`
- 按功能分组添加注释

### 3. 同时更新所有语言 (Update All Languages Simultaneously)

添加新翻译时，务必同时添加所有支持语言的版本：

```javascript
cn: {
  new_key: "新文本",
},
en: {
  new_key: "New Text",
}
```

### 4. 翻译文本的约定 (Translation Text Conventions)

- 保持简洁：适合按钮和标签
- 使用适当的标点符号
- 中文使用全角标点，英文使用半角标点
- 注意语言习惯差异

## 常见问题 (FAQ)

### Q: 如何查找某个文本对应的翻译键？

A: 在 `src/constants/translations.js` 文件中搜索该文本。

### Q: 如何添加新的语言支持？

A: 
1. 在 `TRANSLATIONS` 对象中添加新的语言代码（如 `ja` 日语）
2. 复制现有语言的所有键，翻译为新语言
3. 更新语言切换逻辑以支持新语言
4. 更新 `getSystemLanguage()` 函数以识别新语言

### Q: 翻译缺失时会显示什么？

A: 翻译函数会返回翻译键本身：`t('missing_key')` → `"missing_key"`

### Q: 如何处理带有变量的翻译？

A: 使用 `{{variable}}` 语法并传递参数对象：
```javascript
t('welcome_message', { name: userName })
```

## 维护指南 (Maintenance Guide)

### 定期检查 (Regular Checks)

1. 搜索代码中的硬编码文本（检查是否有中文字符）：
```bash
# 在组件目录中搜索所有包含中文字符的文件
grep -r "[\u4e00-\u9fa5]" src/components/
```

2. 确保所有语言都有对应翻译：
```bash
# 检查翻译键数量是否一致
# 可以手动对比 translations.js 中 cn 和 en 对象的键数量
```

3. 测试语言切换功能是否正常

### 更新日志翻译 (Update Log Translations)

更新日志等长文本内容直接在组件中以对象形式管理，以适应不同语言的表达习惯：

```javascript
const updateLogs = language === 'cn' ? [
  { version: 'V0.6.1', title: '功能更新', content: [...] }
] : [
  { version: 'V0.6.1', title: 'Feature Update', content: [...] }
];
```

## 总结 (Summary)

PromptFill 的多语言系统特点：

1. **集中管理**: 所有翻译集中在一个文件中
2. **简单易用**: 通过 `t()` 函数轻松获取翻译
3. **灵活扩展**: 易于添加新语言和新翻译
4. **类型安全**: 使用字符串键，IDE 可提供提示
5. **支持参数**: 支持动态参数替换

遵循本指南，可以轻松维护和扩展 PromptFill 的多语言支持。
