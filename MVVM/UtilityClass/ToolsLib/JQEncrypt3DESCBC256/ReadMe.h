//
//  ReadMe.h
//  JQ3DES
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#ifndef ReadMe_h
#define ReadMe_h
使用前必读：

JQEncrypt 是用于3DES 256加密解密的库。
支持字符串形式和16进制

字符串加密：doEncryptStr
字符串解密：doDecEncryptStr

十六进制：doEncryptHex
十六进制解密：doEncryptHex

1、设置密匙、偏移量
//密匙 key （与PHP互通 key需大于等于24位）
#define gkey            @"15H2VOsmdNXuwW4XD0BEBkB7"
//偏移量
#define gIv             @"EXu5O7Bw"

2、使用方法

@"是测试字符串，换成您需要加密的内容即可"


JQEncrypt * en = [[JQEncrypt alloc]init];
//加密
NSString * encryptStr = [en doEncryptStr: @"是测试字符串，换成您需要加密的内容即可"];

NSString * encryptHex = [en doEncryptHex: @"是测试字符串，换成您需要加密的内容即可"];

NSLog(@"字符串加密:%@",encryptStr);
NSLog(@"十六进制加密:%@",encryptHex);
//解密
NSString *decEncryptStr = [en doDecEncryptStr:encryptStr];

NSString *decEncryptHex = [en doEncryptHex:encryptHex];

NSLog(@"字符串解密:%@",decEncryptStr);
NSLog(@"字符串解密:%@",decEncryptHex);



php服务器，java服务器，android，ios开发兼容的3des加密解密，

PHP示例

<?php
class DES3 {
    var $key = "15H2VOsmdNXuwW4XD0BEBkB7";
    var $iv = "EXu5O7Bw";
    
    function encrypt($input){
        $size = mcrypt_get_block_size(MCRYPT_3DES,MCRYPT_MODE_CBC);
        $input = $this->pkcs5_pad($input, $size);
        $key = str_pad($this->key,24,'0');
        $td = mcrypt_module_open(MCRYPT_3DES, '', MCRYPT_MODE_CBC, '');
        if( $this->iv == '' )
        {
            $iv = @mcrypt_create_iv (mcrypt_enc_get_iv_size($td), MCRYPT_RAND);
        }
        else
        {
            $iv = $this->iv;
        }
        @mcrypt_generic_init($td, $key, $iv);
        $data = mcrypt_generic($td, $input);
        mcrypt_generic_deinit($td);
        mcrypt_module_close($td);
        $data = base64_encode($data);
        return $data;
    }
    function decrypt($encrypted){
        $encrypted = base64_decode($encrypted);
        $key = str_pad($this->key,24,'0');
        $td = mcrypt_module_open(MCRYPT_3DES,'',MCRYPT_MODE_CBC,'');
        if( $this->iv == '' )
        {
            $iv = @mcrypt_create_iv (mcrypt_enc_get_iv_size($td), MCRYPT_RAND);
        }
        else
        {
            $iv = $this->iv;
        }
        $ks = mcrypt_enc_get_key_size($td);
        @mcrypt_generic_init($td, $key, $iv);
        $decrypted = mdecrypt_generic($td, $encrypted);
        mcrypt_generic_deinit($td);
        mcrypt_module_close($td);
        $y=$this->pkcs5_unpad($decrypted);
        return $y;
    }
    function pkcs5_pad ($text, $blocksize) {
        $pad = $blocksize - (strlen($text) % $blocksize);
        return $text . str_repeat(chr($pad), $pad);
    }
    function pkcs5_unpad($text){
        $pad = ord($text{strlen($text)-1});
        if ($pad > strlen($text)) {
            return false;
        }
        if (strspn($text, chr($pad), strlen($text) - $pad) != $pad){
            return false;
        }
        return substr($text, 0, -1 * $pad);
    }
    function PaddingPKCS7($data) {
        $block_size = mcrypt_get_block_size(MCRYPT_3DES, MCRYPT_MODE_CBC);
        $padding_char = $block_size - (strlen($data) % $block_size);
        $data .= str_repeat(chr($padding_char),$padding_char);
        return $data;
    }
}

$des = new DES3();
echo $ret = $des->encrypt("待加密串11544") . "\n";
echo $des->decrypt($ret) . "\n";



 java(android)示例

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;

/**
 * 3DES加密工具类
 */
public class DES3 {
    // 密钥
    private final static String secretKey = "15H2VOsmdNXuwW4XD0BEBkB7" ;
    // 向量
    private final static String iv = "EXu5O7Bw" ;
    // 加解密统一使用的编码方式
    private final static String encoding = "utf-8" ;
    
    /**
     * 3DES加密
     *
     * @param plainText 普通文本
     * @return
     * @throws Exception
     */
    public static String encode(String plainText) throws Exception {
        Key deskey = null ;
        DESedeKeySpec spec = new DESedeKeySpec(secretKey.getBytes());
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance( "desede" );
        deskey = keyfactory.generateSecret(spec);
        
        Cipher cipher = Cipher.getInstance( "desede/CBC/PKCS5Padding" );
        IvParameterSpec ips = new IvParameterSpec(iv.getBytes());
        cipher.init(Cipher.ENCRYPT_MODE, deskey, ips);
        byte [] encryptData = cipher.doFinal(plainText.getBytes(encoding));
        return Base64.encode(encryptData);
    }
    
    /**
     * 3DES解密
     *
     * @param encryptText 加密文本
     * @return
     * @throws Exception
     */
    public static String decode(String encryptText) throws Exception {
        Key deskey = null ;
        DESedeKeySpec spec = new DESedeKeySpec(secretKey.getBytes());
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance( "desede" );
        deskey = keyfactory.generateSecret(spec);
        Cipher cipher = Cipher.getInstance( "desede/CBC/PKCS5Padding" );
        IvParameterSpec ips = new IvParameterSpec(iv.getBytes());
        cipher.init(Cipher.DECRYPT_MODE, deskey, ips);
        
        byte [] decryptData = cipher.doFinal(Base64.decode(encryptText));
        
        return new String(decryptData, encoding);
    }
    
    public static String padding(String str) {
        byte[] oldByteArray;
        try {
            oldByteArray = str.getBytes("UTF8");
            int numberToPad = 8 - oldByteArray.length % 8;
            byte[] newByteArray = new byte[oldByteArray.length + numberToPad];
            System.arraycopy(oldByteArray, 0, newByteArray, 0,
                             oldByteArray.length);
            for (int i = oldByteArray.length; i < newByteArray.length; ++i) {
                newByteArray[i] = 0;
            }
            return new String(newByteArray, "UTF8");
        } catch (UnsupportedEncodingException e) {
            System.out.println("Crypter.padding UnsupportedEncodingException");
        }
        return null;
    }
    
    /**
     * Base64编码工具类
     *
     */
    public static class Base64 {
        private static final char [] legalChars = "ABCDEFGHIJQLMNOPQRSTUVWXYZabcdefghiJQlmnopqrstuvwxyz0123456789+/" .toCharArray();
        
        public static String encode( byte [] data) {
            int start = 0 ;
            int len = data.length;
            StringBuffer buf = new StringBuffer(data.length * 3 / 2 );
            
            int end = len - 3 ;
            int i = start;
            int n = 0 ;
            
            while (i <= end) {
                int d = (((( int ) data[i]) & 0x0ff ) << 16 ) | (((( int ) data[i + 1 ]) & 0x0ff ) << 8 ) | ((( int ) data[i + 2 ]) & 0x0ff );
                
                buf.append(legalChars[(d >> 18 ) & 63 ]);
                buf.append(legalChars[(d >> 12 ) & 63 ]);
                buf.append(legalChars[(d >> 6 ) & 63 ]);
                buf.append(legalChars[d & 63 ]);
                
                i += 3 ;
                
                if (n++ >= 14 ) {
                    n = 0 ;
                    buf.append( " " );
                }
            }
            
            if (i == start + len - 2 ) {
                int d = (((( int ) data[i]) & 0x0ff ) << 16 ) | (((( int ) data[i + 1 ]) & 255 ) << 8 );
                
                buf.append(legalChars[(d >> 18 ) & 63 ]);
                buf.append(legalChars[(d >> 12 ) & 63 ]);
                buf.append(legalChars[(d >> 6 ) & 63 ]);
                buf.append( "=" );
            } else if (i == start + len - 1 ) {
                int d = ((( int ) data[i]) & 0x0ff ) << 16 ;
                
                buf.append(legalChars[(d >> 18 ) & 63 ]);
                buf.append(legalChars[(d >> 12 ) & 63 ]);
                buf.append( "==" );
            }
            
            return buf.toString();
        }
        
        private static int decode( char c) {
            if (c >= 'A' && c <= 'Z' )
                return (( int ) c) - 65 ;
            else if (c >= 'a' && c <= 'z' )
                return (( int ) c) - 97 + 26 ;
            else if (c >= '0' && c <= '9' )
                return (( int ) c) - 48 + 26 + 26 ;
            else
                switch (c) {
                    case '+' :
                        return 62 ;
                    case '/' :
                        return 63 ;
                    case '=' :
                        return 0 ;
                    default :
                        throw new RuntimeException( "unexpected code: " + c);
                }
        }
        
        /**
         * Decodes the given Base64 encoded String to a new byte array. The byte array holding the decoded data is returned.
         */
        
        public static byte [] decode(String s) {
            
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            try {
                decode(s, bos);
            } catch (IOException e) {
                throw new RuntimeException();
            }
            byte [] decodedBytes = bos.toByteArray();
            try {
                bos.close();
                bos = null ;
            } catch (IOException ex) {
                System.err.println( "Error while decoding BASE64: " + ex.toString());
            }
            return decodedBytes;
        }
        
        private static void decode(String s, OutputStream os) throws IOException {
            int i = 0 ;
            
            int len = s.length();
            
            while ( true ) {
                while (i < len && s.charAt(i) <= ' ' )
                    i++;
                
                if (i == len)
                    break ;
                
                int tri = (decode(s.charAt(i)) << 18 ) + (decode(s.charAt(i + 1 )) << 12 ) + (decode(s.charAt(i + 2 )) << 6 ) + (decode(s.charAt(i + 3 )));
                
                os.write((tri >> 16 ) & 255 );
                if (s.charAt(i + 2 ) == '=' )
                    break ;
                os.write((tri >> 8 ) & 255 );
                if (s.charAt(i + 3 ) == '=' )
                    break ;
                os.write(tri & 255 );
                
                i += 4 ;
            }
        }
    }
    
    public static void main(String[] args) throws Exception{
        String plainText = "待加密串11544";
        String encryptText = DES3.encode(plainText);
        System.out.println(encryptText);
        System.out.println(DES3.decode(encryptText));
        
        
    }
}



#endif /* ReadMe_h */
