<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오늘의집 헤더 클론</title>
    <!-- 프리텐다드 폰트 적용 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Pretendard', sans-serif; }
        a { text-decoration: none; color: inherit; }
        button { border: none; background: none; cursor: pointer; font-family: inherit; }
        
        /* 컨테이너 최대 너비 지정 */
        .header-container { max-width: 1440px; margin: 0 auto; padding: 10px 20px; width: 100%; }

        /* 1. 최상단 파란 배너 */
        .top-event-banner { background-color: #1496f4; color: white; display: flex; justify-content: center; align-items: center; padding: 20px 0; font-size: 16px; font-weight: 700; position: relative; cursor: pointer; transition: background-color 0.2s; }
        .top-event-banner:hover { background-color: #0b80d6; }
        .coupon-icon { background: #fff; color: #1496f4; padding: 3px 8px; border-radius: 4px; font-size: 12px; margin-right: 10px; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; transform: skewX(-5deg); }
        .btn-close { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); font-size: 24px; font-weight: 300; cursor: pointer; line-height: 1; opacity: 0.8; }
        .btn-close:hover { opacity: 1; }

        /* 2. 메인 헤더 영역 */
        .header-main-area { background: #fff; border-bottom: 1px solid #EAEDEF; position: sticky; top: 0; z-index: 100; }
        .header-main-area .header-container { display: flex; justify-content: space-between; align-items: center; height: 90px; }
        
        /* 왼쪽 (로고 + 네비게이션) */
        .header-main-left { display: flex; align-items: center; gap: 45px; }
        .header-logo { cursor: pointer; display: flex; align-items: center; margin-right: 10px; }
        /* 로고 SVG 크기 유지 */
        .header-logo svg { height: 38px; width: auto; } 
        
        /* 메인 네비게이션 */
        .header-main-nav { display: flex; gap: 35px; font-size: 20px; font-weight: 700; color: #2F3438; }
        .header-main-nav a.active { color: #1496f4; }
        .header-main-nav a:hover { color: #1496f4; }

        /* 오른쪽 (검색 + 유저메뉴 + 버튼) */
        .header-main-right { display: flex; align-items: center; gap: 28px; }
        
        /* 통합검색 */
        .header-search { display: flex; align-items: center; background-color: #F7F9FA; border: 1px solid #DADCE0; border-radius: 24px; padding: 0 18px; width: 340px; height: 46px; transition: border-color 0.2s, background-color 0.2s; }
        .header-search:focus-within { border-color: #1496f4; background-color: #fff; }
        .search-icon { width: 22px; height: 22px; color: #828C94; }
        .header-search input { border: none; background: transparent; outline: none; width: 100%; font-size: 16px; margin-left: 8px; color: #2F3438; font-weight: 500; }
        .header-search input::placeholder { color: #9E9E9E; font-weight: 400; }
        
        /* 장바구니 아이콘 */
        .header-cart { cursor: pointer; display: flex; align-items: center; color: #2F3438; transition: color 0.2s; }
        .header-cart svg { width: 32px; height: 32px; }
        .header-cart:hover { color: #1496f4; }
        
        /* 유저 네비게이션 */
        .header-user-nav { display: flex; align-items: center; gap: 16px; font-size: 15px; font-weight: 400; color: #424242; margin-left: -4px; }
        .header-user-nav a { position: relative; padding: 0 4px; transition: color 0.2s; }
        .header-user-nav a:not(:last-child)::after { content: ""; position: absolute; right: -10px; top: 50%; transform: translateY(-50%); width: 1px; height: 14px; background-color: #EAEDEF; }
        .header-user-nav a:hover { color: #1496f4; }
        
        /* 글쓰기 버튼 (화살표 추가 및 간격 조정) */
        .header-btn-write { background-color: #1496f4; color: white; padding: 0 18px; height: 46px; border-radius: 6px; font-size: 16px; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: background-color 0.2s; }
        .header-btn-write:hover { background-color: #0b80d6; }
        .header-btn-write svg { width: 14px; height: 14px; stroke: white; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
    </style>
</head>
<body>

    <header>
        <!-- 1. 최상단 배너 -->
        <div class="top-event-banner">
            <span class="coupon-icon">2만원</span>
            <span>첫 구매라면 누구나 최대 2만원 할인! &gt;</span>
            <span class="btn-close">✕</span>
        </div>

        <!-- 2. 메인 헤더 -->
        <div class="header-main-area">
            <div class="header-container">
                
                <!-- 왼쪽 영역 -->
                <div class="header-main-left">
                    <a href="/" class="header-logo">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 481 136">
                            <path fill="#111" d="M459.317 41.715H443.04c.134 2.783 1.008 5.303 4.532 8.903s9.133 7.32 15.825 11.457l-6.497 10.51c-6.865-4.243-13.264-8.501-17.985-13.322-.983-1.004-1.92-1.884-2.791-2.98a30 30 0 0 1-2.791 3.323c-4.721 4.82-11.12 9.251-17.985 13.494l-6.497-10.51c6.692-4.137 12.3-8.03 15.825-11.63 3.525-3.599 4.398-6.462 4.532-9.245h-16.277V30.73h46.386zM202.316 29.28c17.481 0 26.613 11.252 26.613 24.263v1.758c0 11.355-6.9 21.37-20.325 23.736V91.98h32.522v10.983h-78.087V91.981h32.522V79.04c-13.441-2.358-20.349-12.378-20.349-23.74v-1.758c0-13.01 9.132-24.263 26.613-24.263zm-.245 10.64c-9.429 0-14.073 6.716-14.073 13.79v1.424c0 7.074 4.714 13.79 14.073 13.79s14.073-6.716 14.073-13.79V53.71c0-7.074-4.645-13.79-14.073-13.79m197.014 73.188h-13.043V94.844c-3.364.484-9.354 1.26-18.175 2.086-14.622 1.372-40.328 1.125-40.328 1.125l-.209-11.819s25.813.169 39.599-.952c9.613-.782 16.079-1.739 19.113-2.247V26.154h13.043zM353.77 30.996c14.752 0 22.408 9.841 22.408 21.089v1.757c0 11.247-7.728 21.088-22.408 21.088l-.491-.005c-14.68 0-22.408-9.836-22.408-21.083v-1.757c0-11.248 7.656-21.089 22.408-21.089zm-.245 10.726c-6.727 0-10.126 5.376-10.126 10.706v1.07c0 5.897 3.399 10.684 10.127 10.706 6.662.022 10.124-4.82 10.124-10.706v-1.07c0-5.33-3.462-10.706-10.125-10.706M268.667 43.4h44.696v10.813h-57.739V26.85h13.043zm-23.778 26.215h78.086V58.803h-78.086z"/>
                            <path fill="#111" d="M479.999 99.939c-.011 10.413-2.221 12.533-12.761 12.54-11.69.007-18.439.011-30.148 0-10.245-.01-12.616-2.046-12.697-11.824-.077-9.232.002-25.554.002-25.567h13.043v9.153h29.69V26.155H480s.03 45.359-.001 73.784m-42.561 1.728h29.69V94.71h-29.69zM313.005 74.209l.004 24.48h-45.043v4.739h46.979v10.297h-47.151c-10.653 0-12.846-2.098-12.871-12.595-.01-4.223 0-12.396 0-12.396h45.039v-4.4h-44.691V74.208z"/>
                            <path fill="#00a1ff" d="M75.001 1.243a20.72 20.72 0 0 0-14.136 0c-8.591 3.093-36.22 21.208-51.007 36.46C1.88 45.928 0 51.618 0 61.48v5.078c.126 15.644.914 34.269 3.675 43.324 4.773 15.652 11.949 25.984 57.295 25.984h13.926c45.345 0 52.521-10.332 57.295-25.984 2.761-9.055 3.549-27.68 3.675-43.325v-5.078c0-9.861-1.882-15.551-9.858-23.777-14.789-15.25-42.414-33.366-51.007-36.459"/>
                        </svg>
                    </a>
                    <nav class="header-main-nav">
                        <a href="#" class="active">집구경</a>
                        <a href="#">쇼핑</a>
                        <a href="#">인테리어/생활</a>
                    </nav>
                </div>
                
                <!-- 오른쪽 영역 -->
                <div class="header-main-right">
                    
                    <!-- 둥근 통합 검색창 -->
                    <div class="header-search">
                        <svg class="search-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                        <input type="text" placeholder="통합검색">
                    </div>
                    
                    <!-- 장바구니 아이콘 -->
                    <div class="header-cart">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                    </div>

                    <!-- 유저 메뉴 -->
                    <div class="header-user-nav">
                        <a href="#">로그인</a>
                        <a href="#">회원가입</a>
                        <a href="#">고객센터</a>
                    </div>
                    
                    <!-- 글쓰기 버튼 -->
                    <button class="header-btn-write">
                        글쓰기
                        <!-- ∨ 모양 SVG 아이콘 추가 -->
                        <svg viewBox="0 0 24 24" fill="none"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    
                </div>
            </div>
        </div>
    </header>