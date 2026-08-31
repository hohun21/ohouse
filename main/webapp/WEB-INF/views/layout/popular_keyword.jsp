<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="realtime-keyword-container" id="realtimeKeywordContainer">
    
    <div class="realtime-bar" id="realtimeBar">
        <div class="rolling-content" id="rollingContent">
            <span class="rank-number">1</span>
            <span class="keyword-title">인기 검색어 로딩중...</span>
        </div>
        <span class="arrow-icon" id="toggleArrow">▼</span>
    </div>

    <div class="keyword-dropdown-layer" id="keywordDropdownLayer" style="display: none;">
        <div class="dropdown-header">
            <span>인기 검색어</span>
            <span class="close-icon" id="closeLayerBtn">∧</span>
        </div>
        <ul id="top10KeywordList">
            
        </ul>
    </div>
</div>

<style>
.realtime-keyword-container {
    position: relative;
    display: inline-block;
    font-family: 'Malgun Gothic', sans-serif;
}

.realtime-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    padding: 6px 12px;
    border-radius: 4px;
    background-color: #fff;
    border: 1px solid transparent;
    transition: background 0.2s;
    user-select: none;
    min-width: 210px;
    box-sizing: border-box;
}

.realtime-bar:hover {
    background-color: #F7F9FA;
}

.rolling-content {
    display: flex;
    align-items: center;
    overflow: hidden;
    white-space: nowrap;
    height: 24px;
    position: relative;
    flex: 1;
}

@keyframes fadeInUp {
    0% {
        opacity: 0;
        transform: translateY(6px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

.rolling-item {
    display: flex;
    align-items: center;
    gap: 6px;
    animation: fadeInUp 0.4s ease forwards;
    width: 100%;
}

.rank-number {
    color: #1496f4;
    font-weight: 700;
    min-width: 16px;
    text-align: center;
}

.keyword-title {
    color: #2F3438;
    overflow: hidden;
    text-overflow: ellipsis;
}

.arrow-icon {
    font-size: 11px;
    color: #828C94;
}

/* Top 10 전체 팝업 레이어 박스 */
.keyword-dropdown-layer {
    position: absolute;
    top: 40px;
    right: 0;
    width: 280px;
    background: white;
    border: 1px solid #dbdbdb;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    z-index: 1000;
    padding: 20px;
    box-sizing: border-box;
}

.dropdown-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 15px;
    font-weight: bold;
    color: #292929;
    margin-bottom: 15px;
}

.dropdown-header .close-icon {
    cursor: pointer;
    font-size: 14px;
    color: #757575;
}

#top10KeywordList {
    list-style: none;
    padding: 0;
    margin: 0;
}

#top10KeywordList li {
    display: flex;
    align-items: center;
    padding: 8px 0;
    cursor: pointer;
    font-size: 14px;
}

#top10KeywordList li:hover {
    background-color: #f7f9fa;
}

#top10KeywordList .rank-num {
    width: 24px;
    font-weight: bold;
    color: #333;
    text-align: center;
    margin-right: 12px;
}

#top10KeywordList li:nth-child(1) .rank-num,
#top10KeywordList li:nth-child(2) .rank-num,
#top10KeywordList li:nth-child(3) .rank-num {
    color: #1496f4; 
}

.rank-badge {
    font-size: 11px;
    font-weight: bold;
    margin-right: 6px;
}
.badge-new { color: #ff4d4f; }
.badge-up { color: #ff4d4f; }
.badge-down { color: #2f80ed; }

.keyword-text {
    flex: 1;
    color: #424242;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    let keywordData = [];
    let currentIndex = 0;
    let rollingTimer = null;

    const rollingContent = document.getElementById('rollingContent');
    const realtimeBar = document.getElementById('realtimeBar');
    const dropdownLayer = document.getElementById('keywordDropdownLayer');
    const top10List = document.getElementById('top10KeywordList');
    const closeLayerBtn = document.getElementById('closeLayerBtn');
    const container = document.getElementById('realtimeKeywordContainer');

    // 1. 서버에서 Top 10 인기 검색어 데이터 비동기 호출
    function fetchTopKeywords() {
        fetch('${pageContext.request.contextPath}/search/topKeywords.ajax')
            .then(response => response.json())
            .then(data => {
                if (data && data.length > 0) {
                    keywordData = data;
                    updateRollingView(); 
                    startRolling();
                }
            })
            .catch(error => console.error('인기 검색어 로딩 실패:', error));
    }

    function getBadgeHtml(item) {
        if (item.isNew === 1) {
            return '<span class="rank-badge badge-new">NEW</span>';
        } else if (item.previousRank > item.currentRank) {
            return '<span class="rank-badge badge-up">▲</span>';
        } else if (item.previousRank < item.currentRank) {
            return '<span class="rank-badge badge-down">▼</span>';
        } else {
            return '<span class="rank-badge" style="color: #ccc;">-</span>';
        }
    }

    // 2. 2초마다 애니메이션과 함께 렌더링하는 함수
    function updateRollingView() {
        if (keywordData.length === 0) return;
        const item = keywordData[currentIndex];
        const badgeHtml = getBadgeHtml(item);
        
        rollingContent.innerHTML = `
            <div class="rolling-item">
                <span class="rank-number">\${item.currentRank}</span>
                \${badgeHtml}
                <span class="keyword-title">\${item.keyword}</span>
            </div>
        `;
    }

    function startRolling() {
        if (rollingTimer) clearInterval(rollingTimer);
        rollingTimer = setInterval(() => {
            currentIndex = (currentIndex + 1) % keywordData.length;
            updateRollingView();
        }, 2000);
    }

    // 3. 바를 누르면 Top 10 전체 팝업 레이어 토글
    realtimeBar.addEventListener('click', function(e) {
        e.stopPropagation();
        if (dropdownLayer.style.display === 'none' || dropdownLayer.style.display === '') {
            openLayer();
        } else {
            closeLayer();
        }
    });

    closeLayerBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        closeLayer();
    });

    function openLayer() {
        renderTop10List();
        dropdownLayer.style.display = 'block';
    }

    function closeLayer() {
        dropdownLayer.style.display = 'none';
    }

    // 4. 전체 Top 10 목록 렌더링
    function renderTop10List() {
        top10List.innerHTML = '';
        keywordData.forEach(item => {
            const li = document.createElement('li');
            const badgeHtml = getBadgeHtml(item);

            li.innerHTML = `
                <span class="rank-num">\${item.currentRank}</span>
                \${badgeHtml}
                <span class="keyword-text">\${item.keyword}</span>
            `;

            li.addEventListener('click', function() {
                location.href = '${pageContext.request.contextPath}/search.htm?keyword=' + encodeURIComponent(item.keyword);
            });

            top10List.appendChild(li);
        });
    }

    document.addEventListener('click', function(e) {
        if (!container.contains(e.target)) {
            closeLayer();
        }
    });

    fetchTopKeywords();
});
</script>