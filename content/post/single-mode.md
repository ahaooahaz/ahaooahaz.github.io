---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/IMG_20201003_180559.webp
urlname: single-mode
slug: single-mode
date: 2022-01-16 23:30:52
title: 单例模式
tags:
  - technical
---

<!--more-->

# 单例模式

程序中只存在一个单独的对象，单例模式的写法分为两种:

- 懒汉模式: 在使用的时候才创建。
- 饿汉模式: 在程序启动时就创建。

## 懒汉模式

```cpp
#define sync() __asm__ volatile ("lwsync")

class Instance {
    public:
        static Instance* GetInstance() {
            if (!_inst) {
                _mtx.Lock();
                if (!_inst) {
                    Instance* t = new Instance;
                     sync();
                    _inst = t;
                }
                _mtx.Unlock();
            }

            return _inst;
        }
    
    private:
        Instance();
        Instance(const Instance&);

    private:
        Instance* _inst;
        mutex _mtx;
};
```

### double check

两次判断的意义在于两方面:

1. 效率: 避免并发时单次判断需要重复对互斥锁的加解锁操作
2. 安全: 获取单例对象的并发安全性

### sync

sync需要保证sync之后作用域的代码不会因为编译器的优化导致执行顺序的改变。

如果构造单例对象时使用`_inst = new Instance;`会产生并发安全问题，其内部的调用顺序为:

1. 开辟内存空间
2. 在内存位置执行构造函数
3. 将内存位置赋值给_inst

其中，2和3的执行顺序是可以被改变的，当3先与2执行时，会产生`_Inst!=nullptr`且并未调用构造函数的现象。


## 饿汉模式

```cpp

Instance* Instance::_inst = new Instance;

class Instance {
    public:
        static Instance* GetInstance() {
            return _inst;
        }

    private:
        Instance();
        Instance(const Instance&);

    private:
        static Instance* _inst;
        mutex _mtx;
};
```
