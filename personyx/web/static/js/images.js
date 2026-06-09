document.addEventListener("DOMContentLoaded", () => {
    const grid = document.getElementById("imageGrid");
    const ITEMS_PER_PAGE = parseInt(grid.dataset.itemsPerPage, 10) || 24;
    const loadMoreBtn = document.getElementById("loadMoreBtn");
    const modal = document.getElementById("imageDetailModal");
    const modalImg = document.getElementById("modalImage");
    const modalClose = document.getElementById("modalClose");
    const downloadBtn = document.getElementById("downloadBtn");

    // グリッドが無ければ処理を抜ける
    if (!grid) return;

    // load moreボタン
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener("click", () => {
            const hiddenCards = grid.querySelectorAll(".gallery-card.hidden-card");
            
            for (let i = 0; i < Math.min(ITEMS_PER_PAGE, hiddenCards.length); i++) {
                hiddenCards[i].classList.remove("hidden-card");
            }

            if (grid.querySelectorAll(".gallery-card.hidden-card").length === 0) {
                loadMoreBtn.parentElement.style.display = "none";
            }
        });
    }

    // グリッド内イベントデリゲーション
    grid.addEventListener("click", (e) => {
        const card = e.target.closest(".gallery-card");
        if (!card) return;

        if (e.target.classList.contains("info-trigger-btn")) {
            e.stopPropagation();
            const overlay = card.querySelector(".meta-overlay");
            overlay.classList.add("active");
            return;
        }

        if (e.target.classList.contains("close-overlay-btn")) {
            e.stopPropagation();
            const overlay = card.querySelector(".meta-overlay");
            overlay.classList.remove("active");
            return;
        }

        if (e.target.classList.contains("preview-btn") || !e.target.closest(".meta-overlay")){
            const imgElement = card.querySelector(".image-wrapper img");
            if (imgElement && modalImg && downloadBtn && modal) {
                const srcPath = imgElement.getAttribute("src");
                const filename = imgElement.src.split("/").pop();
                modalImg.setAttribute("src", srcPath);
                downloadBtn.setAttribute("href", srcPath);
                downloadBtn.setAttribute("download", filename);
                modal.style.display = "flex";
            }
        }
    });

    const closeModal = () => {
        if (modal && modalImg) {
            modal.style.display = "none";
            modalImg.setAttribute("src", "");
        }
    }

    if (modalClose) {
        modalClose.addEventListener("click", closeModal);
    }
    if (modal) {
        modal.addEventListener("click", (e) => {
            if (e.target === modal) {
                closeModal();
            }
        });
    }

});