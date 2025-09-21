# install ethtool
```
sudo pacman -S ethtool
```

## Check eth-interface
```
ip link
```

## Check wol Support
```
sudo ethtool eno1
```

Look for:
```
Supports Wake-on: pumbg
Wake-on: d
```

# Install wol
```
sudo pacman -S wol
```

```
wol <MAC-ADDRESS>
```


